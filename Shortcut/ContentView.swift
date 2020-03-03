//
//  ContentView.swift
//  Shortcut
//
//  Created by Kevin Titor on 29/2/2020.
//  Copyright © 2020 Kevin Titor. All rights reserved.
//

import SwiftUI

func filterGroups(groups: [ShortcutGroup], keyword: String) -> [ShortcutGroup] {
    var result:[ShortcutGroup]  = []
    
    for group in groups {
        var items: [ShortcutItem] = []
        
        if keyword == "" {
            items = group.items
        } else {
            items = group.items.filter { (item) -> Bool in
                "\(group.title) \(item.title)".localizedCaseInsensitiveContains(keyword)
            }
        }
        
        if items.count > 0 {
            result.append(ShortcutGroup(title: group.title, items: items))
        }
    }
    
    return result
}

struct ContentView: View {
    @State var appShortcuts: [ShortcutGroup] = []
    var window: ActiveWindow? = nil
    
    @State var keyword: String = ""
    @State var loading: Bool = true
    
    func getShortcuts(window: ActiveWindow) -> [ShortcutGroup]? {
        let appShortcuts = getAppShortcuts(appPid: window.pid)
        if appShortcuts != nil {
            return appShortcuts!
        } else {
            print("No shortcuts found")
        }
        return nil
    }
    
    func didMount() {
        DispatchQueue.main.async {
            print("got window", Date())
            NSApp.activate(ignoringOtherApps: true)
            if (self.window != nil) {
                print("Bundle id \(self.window!.bundleId)")
                let data = readJSONFromFile(fileName: self.window!.bundleId)
                if data == nil {
                    print("read shortcuts from menu on the fly", Date())
                    self.appShortcuts = self.getShortcuts(window: self.window!)!
                    print("loaded", Date())
                } else {
                    self.appShortcuts = data!
                }
            }
            self.loading = false
        }
    }
    
    var body: some View {
        VStack {
            if self.loading == true {
                LoadingView()
                Text("")
                    .onAppear(perform: didMount)
            } else if self.window == nil {
                HStack(alignment: .center) {
                    Text("No active window")
                    Spacer()
                }
                .scaledToFit()
                .frame(width: 400, height: 500, alignment: .leading)
            } else {
                VStack(spacing:0 ) {
                    Header(icon: self.window!.icon)
                    
                    
                    VStack {
                        SearchBar(text: $keyword)
                    }.padding(.leading, 10)
                        .padding(.trailing, 10)
                        .padding(.bottom, 10)
                    
                    ScrollView {
                        ForEach(filterGroups(groups: self.appShortcuts, keyword: self.keyword), id: \.title) { group in
                            ShortcutGroupView(group: group)
                        }
                    }
                }
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(
            appShortcuts:
            [
                ShortcutGroup(title: "File", items: [
                    ShortcutItem(title: "First keys", keys: ["cmd", "shift", "x"]),
                    ShortcutItem(title: "Second keys", keys: ["cmd", "shift", "y"]),
                    ShortcutItem(title: "First keys", keys: ["cmd", "shift", "x"]),
                    ShortcutItem(title: "Second keys", keys: ["cmd", "shift", "y"]),
                    ShortcutItem(title: "First keys", keys: ["cmd", "shift", "x"]),
                    ShortcutItem(title: "Second keys", keys: ["cmd", "shift", "y"]),
                    ShortcutItem(title: "First keys", keys: ["cmd", "shift", "x"]),
                    ShortcutItem(title: "Second keys", keys: ["cmd", "shift", "y"]),
                    ShortcutItem(title: "First keys", keys: ["cmd", "shift", "x"]),
                    ShortcutItem(title: "Second keys", keys: ["cmd", "shift", "y"]),
                    ShortcutItem(title: "First keys", keys: ["cmd", "shift", "x"]),
                    ShortcutItem(title: "Second keys", keys: ["cmd", "shift", "y"])
                ]),
                ShortcutGroup(title: "Edit", items: [
                    ShortcutItem(title: "First keys", keys: ["cmd", "shift", "x"]),
                    ShortcutItem(title: "Second keys", keys: ["cmd", "shift", "y"])
                ]),
                ShortcutGroup(title: "Edit", items: [
                    ShortcutItem(title: "First keys", keys: ["cmd", "shift", "x"]),
                    ShortcutItem(title: "Second keys", keys: ["cmd", "shift", "y"])
                ]),
                ShortcutGroup(title: "Edit", items: [
                    ShortcutItem(title: "First keys", keys: ["cmd", "shift", "x"]),
                    ShortcutItem(title: "Second keys", keys: ["cmd", "shift", "y"])
                ]),
                ShortcutGroup(title: "Edit", items: [
                    ShortcutItem(title: "First keys", keys: ["cmd", "shift", "x"]),
                    ShortcutItem(title: "Second keys", keys: ["cmd", "shift", "y"])
                ]),
                ShortcutGroup(title: "Edit", items: [
                    ShortcutItem(title: "First keys", keys: ["cmd", "shift", "x"]),
                    ShortcutItem(title: "Second keys", keys: ["cmd", "shift", "y"])
                ])
            ],
            window: ActiveWindow(
                title: "Active App",
                pid: Int32(12),
                icon: NSImage(
                    size: NSSize(width: 50, height: 60)
                ),
                bundleId: "com.example.xxx"
            )
        )
    }
}
