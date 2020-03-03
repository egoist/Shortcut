//
//  ShortcutGroupView.swift
//  Shortcut
//
//  Created by Kevin Titor on 29/2/2020.
//  Copyright © 2020 Kevin Titor. All rights reserved.
//

import SwiftUI


struct ShortcutGroupView: View {
    var group: ShortcutGroup
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Section(header: HStack {
                Text(self.group.title)
                    .padding(.leading, 10)
                    .padding(.top, 5)
                    .padding(.bottom, 5)
                    .padding(.trailing,10)
                Spacer()
            }.background(Color("GroupTitleBackgroundColor"))) {
                ForEach(self.group.items, id: \.title) { item in
                    HStack(spacing: 0) {
                        Text(item.title)
                        Spacer()
                        KeysView(keys: item.keys)
                    }
                    .padding(.leading, 10)
                    .padding(.trailing, 10)
                    .padding(.top, 5)
                    .padding(.bottom, 5)
                }
            }
        }
    }
}



struct ShortcutGroupView_Previews: PreviewProvider {
    static var previews: some View {
        ShortcutGroupView(
            group:
            ShortcutGroup(
                title: "File",
                items: [
                    ShortcutItem(title: "Copy file", keys: ["cmd", "c"]),
                    ShortcutItem(title: "Move file", keys: ["cmd", "m"])
                ]
            )
        )
    }
}
