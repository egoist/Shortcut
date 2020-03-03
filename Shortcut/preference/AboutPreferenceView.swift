//
//  AboutPreferenceView.swift
//  Shortcut
//
//  Created by Kevin Titor on 2/3/2020.
//  Copyright © 2020 Kevin Titor. All rights reserved.
//

import SwiftUI
import Preferences

let AboutPreferencePaneViewController: () -> PreferencePane = {
    PreferencePaneHostingController(preferencePaneView: AboutPreferencePane())
}

struct AboutPreferencePane: View, PreferencePaneView {
    // Same as PreferencePane protocol
    let preferencePaneIdentifier: PreferencePaneIdentifier = PreferencePane.Identifier.about
    let preferencePaneTitle: String = "About"
    let toolbarItemIcon: NSImage = NSImage(named: NSImage.infoName)!
    
    let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as! String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(appName).fontWeight(.bold).font(.system(size: 20))
            HStack(spacing: 0) {
                Text("v")
                Text(appVersion)
            }.padding(.top, 5)
            Text("Made by EGOIST (Kevin Titor)")
                .italic().padding(.top, 5)
        }.padding(20.0).frame(alignment: .leading)
        
    }
}

struct AboutPreferencePane_Previews: PreviewProvider {
    static var previews: some View {
        AboutPreferencePane()
    }
}
