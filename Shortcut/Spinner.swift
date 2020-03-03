//
//  Spinner.swift
//  Shortcut
//
//  Created by Kevin Titor on 1/3/2020.
//  Copyright © 2020 Kevin Titor. All rights reserved.
//
import SwiftUI

struct Spinner: NSViewRepresentable {
    func makeNSView(context: NSViewRepresentableContext<Spinner>) -> NSProgressIndicator {
        NSProgressIndicator()
    }

    func updateNSView(_ nsView: NSProgressIndicator, context: NSViewRepresentableContext<Spinner>) {
        nsView.isIndeterminate = true
        nsView.style = .spinning
        nsView.startAnimation(self)
    }
}
