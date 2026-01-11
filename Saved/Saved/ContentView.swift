//
//  ContentView.swift
//
//  Created by Play to Xcode
//

import SwiftUI
import SaveIt

struct ContentView: View {
    var body: some View {
        Pages.Home()
            .ignoresSafeArea()
    }
}

#Preview {
    ContentView()
}
