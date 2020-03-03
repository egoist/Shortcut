//
//  AppDelegate.swift
//  Shortcut
//
//  Created by Kevin Titor on 29/2/2020.
//  Copyright © 2020 Kevin Titor. All rights reserved.
//

import Cocoa
import SwiftUI
import Preferences
import Magnet

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)
    let popover = NSPopover()
    
    var eventMonitor: EventMonitor?
    var activeWindow: ActiveWindow?
    
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        if let button = statusItem.button {
            button.image = NSImage(named:NSImage.Name("ShortcutStatusBarImage"))
            button.action = #selector(togglePopover(_:))
        }
        popover.contentSize = NSSize(width: 400, height: 500)
        popover.behavior = .transient
        
        // Close popover when blurred
        eventMonitor = EventMonitor(mask: [NSEvent.EventTypeMask.leftMouseDown, NSEvent.EventTypeMask.rightMouseDown]) { [unowned self] event in
            if self.popover.isShown {
                self.closePopover(sender: event)
            }
        }
        eventMonitor?.start()
        
        HotKeyService.registerDefaultHotKey()
      }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        HotKeyCenter.shared.unregisterAll()
    }
    
    @objc func togglePopover(_ sender: Any?) {
        if popover.isShown {
            closePopover(sender: sender)
        } else {
            showPopover(sender: sender)
        }
    }
    
    func showPopover(sender: Any?) {        
        if let button = statusItem.button {
            activeWindow = getActiveWindow()
            popover.contentViewController = NSHostingController(rootView: ContentView(window: activeWindow))
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
        }
    }
    
    func closePopover(sender: Any?) {
        popover.performClose(sender)
        if activeWindow != nil {
            NSRunningApplication(processIdentifier: activeWindow!.pid)!.activate(options: .activateIgnoringOtherApps)
        }
    }
}

extension PreferencePane.Identifier {
    static let general = Identifier("general")
    static let about = Identifier("about")
}
