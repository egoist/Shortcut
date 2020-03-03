//
//  KeysView.swift
//  Shortcut
//
//  Created by Kevin Titor on 29/2/2020.
//  Copyright © 2020 Kevin Titor. All rights reserved.
//

import SwiftUI

let keyboardSymbol = [
    "Command": "⌘",
    "Meta": "⌘",
    "Option": "⌥",
    "Alt": "⌥",
    "Control": "⌃",
    "Shift": "⇧",
    "Delete": "⌫",
    "Escape": "⎋"
]

struct KeysView: View {
    @State var keys: [String] = []
    
    func getSymbol(key: String) -> String {
        if keyboardSymbol[key] != nil {
            return keyboardSymbol[key]!
        }
        return key
    }
    
    var body: some View {
        HStack {
            ForEach(self.keys, id: \.self) { key in
                Text(self.getSymbol(key: key))
                    .frame(minWidth: 20)
                    .padding(.top, 2)
                    .padding(.bottom, 2)
                    .padding(.leading, 4)
                    .padding(.trailing, 4)
                    .overlay(
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(Color.gray, lineWidth: 1)
                )
            }
        }
    }
}

struct KeysView_Previews: PreviewProvider {
    static var previews: some View {
        KeysView(keys: ["Command", "Shift", "xxx"])
            .padding(10)
    }
}
