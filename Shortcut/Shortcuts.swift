//
//  Shortcuts.swift
//  Shortcut
//
//  Created by Kevin Titor on 29/2/2020.
//  Copyright © 2020 Kevin Titor. All rights reserved.
//

import AppKit

let modifiers = [
    ["Meta"],
    ["Shift", "Meta"],
    ["Alt", "Meta"],
    ["Alt", "Shift", "Meta"],
    ["Control", "Meta"],
    ["Control", "Shift", "Meta"],
    ["Control", "Alt", "Meta"],
    ["Control", "Alt", "Shift", "Meta"],
    [],
    ["Shift"],
    ["Alt"],
    ["Alt", "Shift"],
    ["Control"],
    ["Control", "Shift"],
    ["Control", "Alt"],
    ["Control", "Alt", "Shift"],
]

func getValue<T>(of element: AXUIElement, attribute: String, as type: T.Type) -> T? {
    var value: AnyObject?
    let result = AXUIElementCopyAttributeValue(element, attribute as CFString, &value)
    
    if result == .success, let typedValue = value as? T {
        return typedValue
    }
    
    return nil
}

struct ShortcutGroup: Decodable {
    var title: String
    var items: [ShortcutItem] = []
    var description: String?
}

struct ShortcutItem: Decodable {
    var title: String
    var keys: [String]
}

func getShortcutItem(menuItem: AXUIElement, groupTitle: String) -> ShortcutItem? {
    guard let title = getValue(
        of: menuItem,
        attribute: kAXTitleAttribute,
        as: String.self
        ) else {
            return nil
    }
    
    if title == "" {
        return nil
    }
    
    guard let cmdchar = getValue(
        of: menuItem,
        attribute: kAXMenuItemCmdCharAttribute,
        as: String.self
        ) else {
            return nil
    }
    
    guard let cmdmod = getValue(
        of: menuItem,
        attribute: kAXMenuItemCmdModifiersAttribute,
        as: Int.self
        ) else {
            return nil
    }
    
    
    return ShortcutItem(title: title, keys: modifiers[cmdmod] + [cmdchar.lowercased()])
}

func getShortcuts(app: NSRunningApplication) -> [ShortcutGroup]? {
    var groups = [] as [ShortcutGroup]
    let app = AXUIElementCreateApplication(app.processIdentifier)
    
    guard let menuBar = getValue(
        of: app,
        attribute: kAXMenuBarAttribute,
        as: AXUIElement.self
        ) else {
            return nil
    }
    
    guard let menuBarItems = getValue(
        of: menuBar,
        attribute: kAXChildrenAttribute,
        as: NSArray.self
        ) else {
            return nil
    }
    
    
    for menuBarItem in menuBarItems {
        guard let groupTitle = getValue(
            of: menuBarItem as! AXUIElement,
            attribute: kAXTitleAttribute,
            as: String.self
            ) else {
                continue
        }
        
        if groupTitle == "Apple" {
            continue
        }
        
        var group = ShortcutGroup(title: groupTitle)
        
        guard let menus = getValue(
            of: menuBarItem as! AXUIElement,
            attribute: kAXChildrenAttribute,
            as: NSArray.self
            ) else {
                continue
        }
        
        for menu in menus {
            guard let menuItems = getValue(
                of: menu as! AXUIElement,
                attribute: kAXChildrenAttribute,
                as: NSArray.self
                ) else {
                    continue
            }
            
            for menuItem in menuItems {
                guard let subMenus = getValue(
                    of: menuItem as! AXUIElement,
                    attribute: kAXChildrenAttribute,
                    as: NSArray.self
                    ) else {
                        continue
                }
                
                guard let subGroupTitle = getValue(
                    of: menuItem as! AXUIElement,
                    attribute: kAXTitleAttribute,
                    as: String.self
                    ) else {
                        continue
                }
                
                if subMenus.count > 0 {
                    for subMenu in subMenus {
                        guard let subMenusItems = getValue(
                            of: subMenu as! AXUIElement,
                            attribute: kAXChildrenAttribute,
                            as: NSArray.self
                            ) else {
                                continue
                        }
                        
                        for subMenusItem in subMenusItems {
                            guard let item = getShortcutItem(menuItem: subMenusItem as! AXUIElement, groupTitle: subGroupTitle) else {
                                continue
                            }
                            
                            group.items.append(item)
                        }
                    }
                }
                
                guard let item = getShortcutItem(menuItem: menuItem as! AXUIElement, groupTitle: groupTitle) else {
                    continue
                }
                
                group.items.append(item)
            }
        }
        
        groups.append(group)
    }
    
    return groups
}

func getAppShortcuts(appPid: Int32) -> [ShortcutGroup]? {
    let app = NSRunningApplication(processIdentifier: appPid)!
    return getShortcuts(app: app)
}

