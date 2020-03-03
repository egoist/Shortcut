//
//  main.swift
//  Shortcut
//
//  Created by Kevin Titor on 29/2/2020.
//  Copyright © 2020 Kevin Titor. All rights reserved.
//

import AppKit

func getActiveBrowserTabURLAppleScriptCommand(_ appName: String) -> String? {
    switch appName {
    case "Google Chrome", "Brave Browser", "Microsoft Edge":
        return "tell app \"\(appName)\" to get the URL of active tab of front window"
    case "Safari":
        return "tell app \"Safari\" to get URL of front document"
    default:
        return nil
    }
}

@discardableResult
func runAppleScript(source: String) -> String? {
    NSAppleScript(source: source)?.executeAndReturnError(nil).stringValue
}



// Show the system prompt if there's no permission.
func hasScreenRecordingPermission() -> Bool {
    CGDisplayStream(
        dispatchQueueDisplay: CGMainDisplayID(),
        outputWidth: 1,
        outputHeight: 1,
        pixelFormat: Int32(kCVPixelFormatType_32BGRA),
        properties: nil,
        queue: DispatchQueue.global(),
        handler: { _, _, _, _ in }
        ) != nil
}

struct ActiveWindow {
    let title: String
    let pid: Int32
    let icon: NSImage
    let bundleId: String
}

func getActiveWindow() -> ActiveWindow? {
    // Show accessibility permission prompt if needed. Required to get the complete window title.
    let options : NSDictionary = [kAXTrustedCheckOptionPrompt.takeRetainedValue() as NSString: true]
    let accessibilityEnabled = AXIsProcessTrustedWithOptions(options)
    if !accessibilityEnabled {
        print("active-win requires the accessibility permission in “System Preferences › Security & Privacy › Privacy › Accessibility”.")
        return nil
    }
    
    let frontmostAppPID = NSWorkspace.shared.frontmostApplication!.processIdentifier
    print(frontmostAppPID)
    let windows = CGWindowListCopyWindowInfo([.optionOnScreenOnly, .excludeDesktopElements], kCGNullWindowID) as! [[String: Any]]
    
    // Show screen recording permission prompt if needed. Required to get the complete window title.
    if !hasScreenRecordingPermission() {
        print("active-win requires the screen recording permission in “System Preferences › Security & Privacy › Privacy › Screen Recording”.")
        return nil
    }
    
    for window in windows {
        let windowOwnerPID = window[kCGWindowOwnerPID as String] as! Int
        if windowOwnerPID != frontmostAppPID {
            continue
        }
        
        // Skip transparent windows, like with Chrome.
        if (window[kCGWindowAlpha as String] as! Double) == 0 {
            continue
        }
        
        let bounds = CGRect(dictionaryRepresentation: window[kCGWindowBounds as String] as! CFDictionary)!
        
        // Skip tiny windows, like the Chrome link hover statusbar.
        let minWinSize: CGFloat = 50
        if bounds.width < minWinSize || bounds.height < minWinSize {
            continue
        }
        
        let appPid = window[kCGWindowOwnerPID as String] as! pid_t
        let app = NSRunningApplication(processIdentifier: appPid)!

        return ActiveWindow(
            title: window[kCGWindowName as String] as! String,
            pid: appPid,
            icon: NSRunningApplication(processIdentifier: appPid)!.icon!,
            bundleId: app.bundleIdentifier!
        )
    }
    return nil
}
