//
//  GeneralPreferenceView.swift
//  Shortcut
//
//  Created by Kevin Titor on 2/3/2020.
//  Copyright © 2020 Kevin Titor. All rights reserved.
//

import SwiftUI
import Preferences
import LoginServiceKit

let GeneralPreferencePaneViewController: () -> PreferencePane = {
    PreferencePaneHostingController(preferencePaneView: GeneralPreferencePane())
}

class Store: ObservableObject {
    @Published var launchAtLogin = LoginServiceKit.isExistLoginItems() {
        didSet {
            if launchAtLogin {
                LoginServiceKit.addLoginItems()
            } else {
                LoginServiceKit.removeLoginItems()
            }
        }
    }
}

struct GeneralPreferencePane: View, PreferencePaneView {
    // Same as PreferencePane protocol
    let preferencePaneIdentifier: PreferencePaneIdentifier = PreferencePane.Identifier.general
    let preferencePaneTitle: String = "General"
    let toolbarItemIcon: NSImage = NSImage(named: NSImage.preferencesGeneralName)!
    
    @ObservedObject var store = Store()
    
    func recordShortcut() {
        print("record")
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Toggle(isOn: $store.launchAtLogin) {
                Text("Launch at Login")
                    .padding(.leading, 5)
            }.padding(0)
            VStack {
                Text("Show/hide this app:")
            }.padding(.top, 10)
            VStack {
                
                ShortcutRecord()
            }
            .frame(width: 200.0, height: 30.0, alignment: .leading)
        }.frame(alignment: .leading)
            .padding(20)
    }
}

struct GeneralPreferencePane_Previews: PreviewProvider {
    static var previews: some View {
        GeneralPreferencePane()
    }
}
