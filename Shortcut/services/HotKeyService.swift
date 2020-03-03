//
//  HotKeyService.swift
//  Shortcut
//
//  Created by Kevin Titor on 3/3/2020.
//  Copyright © 2020 Kevin Titor. All rights reserved.
//

import Foundation
import Magnet

final class HotKeyService: NSObject {
}

extension HotKeyService {
    static func getStoredKeyCombo() -> KeyCombo? {
        guard let data = UserDefaults.standard.data(forKey: "MenubarHotKey") else {
            return nil
        }
        do {
            guard let keyCombo = try NSKeyedUnarchiver.unarchiveObject(with: data) as? KeyCombo else { return nil  }
            return keyCombo
        } catch {
            return nil
        }
    }
    
    
    static func registerDefaultHotKey() {
        let keyCombo = getStoredKeyCombo()
        if keyCombo == nil {
            return
        }
        
        let hotKey = HotKey(identifier: "MenubarHotKey", keyCombo: keyCombo!) {hotKey in
            let appDelegate = NSApplication.shared.delegate as! AppDelegate
            appDelegate.togglePopover(nil)
        }
        hotKey.register()
        print("register default key", keyCombo)
    }
    
    static func registerNewHotKey(keyCombo: KeyCombo) {
        print("register", keyCombo)
        clearHotKey()
        let hotKey = HotKey(identifier: "MenubarHotKey", keyCombo: keyCombo) {hotKey in
            let appDelegate = NSApplication.shared.delegate as! AppDelegate
            appDelegate.togglePopover(nil)
        }
        hotKey.register()
        
        // Store the key
        do {
            let archivedKey = try NSKeyedArchiver.archivedData(withRootObject: keyCombo, requiringSecureCoding: false)
            UserDefaults.standard.set(archivedKey, forKey: "MenubarHotKey")
            // You have to do this for storing object!!
            UserDefaults.standard.synchronize()
            print("saved keycombo", archivedKey)
        } catch {
            print("Cannot save the key")
        }
    }
    
    static func clearHotKey() {
        HotKeyCenter.shared.unregisterHotKey(with: "MenubarHotKey")
        UserDefaults.standard.removeObject(forKey: "MenubarHotKey")
    }
}
