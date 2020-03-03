//
//  ShortcutRecord.swift
//  Shortcut
//
//  Created by Kevin Titor on 3/3/2020.
//  Copyright © 2020 Kevin Titor. All rights reserved.
//

import SwiftUI
import KeyHolder
import Magnet

struct ShortcutRecord: NSViewRepresentable {
    func makeCoordinator() -> ShortcutRecord.Coordinator {
        return ShortcutRecord.Coordinator()
    }
    
    func makeNSView(context: NSViewRepresentableContext<ShortcutRecord>) -> RecordView {
        let recordView = RecordView(frame: CGRect.zero)
        let keyCombo = HotKeyService.getStoredKeyCombo()
        print("keycombo", keyCombo)
        recordView.keyCombo = keyCombo
        recordView.tintColor = NSColor(red: 0.164, green: 0.517, blue: 0.823, alpha: 1)
        recordView.delegate = context.coordinator
        recordView.backgroundColor = .controlBackgroundColor
        recordView.borderColor = .controlShadowColor
        recordView.cornerRadius = 5.0
        return recordView
    }
    
    
    func updateNSView(_ nsView: RecordView, context: NSViewRepresentableContext<ShortcutRecord>) {
        
    }
    
    class Coordinator: NSObject, RecordViewDelegate {
        func recordViewShouldBeginRecording(_ recordView: RecordView) -> Bool {
            return true
        }
        
        func recordView(_ recordView: RecordView, canRecordKeyCombo keyCombo: KeyCombo) -> Bool {
            return true
        }
        
        func recordViewDidClearShortcut(_ recordView: RecordView) {
            HotKeyService.clearHotKey()
        }
        
        func recordView(_ recordView: RecordView, didChangeKeyCombo keyCombo: KeyCombo) {
            HotKeyService.registerNewHotKey(keyCombo: keyCombo)
        }
        
        func recordViewDidEndRecording(_ recordView: RecordView) {
            
        }        
    }
}

struct ShortcutRecord_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            ShortcutRecord()
        }
        .frame(width: 200.0, height: 30.0, alignment: .leading)
    }
}
