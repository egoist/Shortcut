//
//  SearchBar.swift
//  Shortcut
//
//  Created by Kevin Titor on 1/3/2020.
//  Copyright © 2020 Kevin Titor. All rights reserved.
//

import SwiftUI

struct SearchBar: NSViewRepresentable {
    @Binding var text: String
    
    
    func makeCoordinator() -> SearchBar.Coordinator {
        return SearchBar.Coordinator(binding: $text)
    }
        
    func makeNSView(context: NSViewRepresentableContext<SearchBar>) -> NSSearchField {
        let searchBar = NSSearchField()
        searchBar.delegate = context.coordinator
        return searchBar
    }
    
    func updateNSView(_ nsView: NSSearchField, context: NSViewRepresentableContext<SearchBar>) {
        nsView.stringValue = text
        if context.coordinator.isFirstResponder == false {
            context.coordinator.isFirstResponder = true
            nsView.becomeFirstResponder()
        }
    }
    
    class Coordinator: NSObject, NSSearchFieldDelegate {
        var binding: Binding<String>
        var isFirstResponder = false

        
        init(binding: Binding<String>) {
            self.binding = binding
            super.init()
        }
        
        func controlTextDidChange(_ obj: Notification) {
            guard let field = obj.object as? NSTextField else { return }
            binding.wrappedValue = field.stringValue
        }
    }
}
