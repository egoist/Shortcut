//
//  Header.swift
//  Shortcut
//
//  Created by Kevin Titor on 2/3/2020.
//  Copyright © 2020 Kevin Titor. All rights reserved.
//

import SwiftUI
import Preferences

struct Header: View {
    let icon: NSImage
    
    func openPreferences() {
        let preferencesWindowController = PreferencesWindowController(
            preferencePanes: [
                GeneralPreferencePaneViewController(),
                AboutPreferencePaneViewController()
            ],
            style: .toolbarItems,
            animated: true,
            hidesToolbarForSingleItem: true
        )
        preferencesWindowController.show()
    }
    
    var body: some View {
        HStack() {
            Image(nsImage: icon)
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
            Spacer()
            Image("gear")
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
                .onTapGesture {
                    self.openPreferences()
            }
        }
        .padding(10)
    }
}

struct Header_Previews: PreviewProvider {
    static var previews: some View {
        Header(icon: NSImage(
            size: NSSize(width: 50, height: 60)
        ))
    }
}
