//
//  LoadingView.swift
//  Shortcut
//
//  Created by Kevin Titor on 1/3/2020.
//  Copyright © 2020 Kevin Titor. All rights reserved.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        HStack(alignment: .center) {
            Spinner()
            Spacer()
        }
        .scaledToFit()
        .frame(width: 400, height: 500, alignment: .leading)
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
