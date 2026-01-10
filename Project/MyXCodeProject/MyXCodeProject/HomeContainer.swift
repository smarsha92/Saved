//
//  HomeContainer.swift
//
//  Created by Play to Xcode
//

import SwiftUI
import UIKit
import SaveIt

// Helper to attach Play update callbacks if needed later
extension SUI.Pages.Home {
    func onUpdate(_ playId: String, perform: @escaping (Any?) -> Void) -> Self {
        var copy = self
        copy.playIdToUpdateCall[playId] = perform
        return copy
    }
}

struct HomeContainer: View {
    @State private var showShareSheet = false
    @State private var urlText: String = ""
    @State private var savedURL: URL?

    // If you have a Play button that should open this sheet, replace the
    // placeholder below with the actual Play ID and uncomment the `.onUpdate`.
    // private let openSheetButtonPlayId = "<replace-with-button-play-id>"

    var body: some View {
        ZStack {
            // Bind the Home text element to our state so it updates live
            Pages.Home()
                .setText(.text1, value: urlText.isEmpty ? "" : urlText)
                .ignoresSafeArea()
                .onTapGesture {
                    guard let savedURL else { return }
                    UIApplication.shared.open(savedURL, options: [:], completionHandler: nil)
                }

            if showShareSheet {
                URLShareSheet(urlText: urlText, onSave: { normalizedURL in
                    // Dismiss and keep the text (Home already reflects it)
                    urlText = normalizedURL.absoluteString
                    savedURL = normalizedURL
                    withAnimation(.easeInOut) { showShareSheet = false }
                }, onCancel: {
                    // Dismiss without applying changes
                    withAnimation(.easeInOut) { showShareSheet = false }
                })
                .transition(.opacity.combined(with: .scale))
            }
        }
        // TEMP: For now, present the sheet with a long-press anywhere.
        // Replace this with your Play button callback once you provide the Play ID.
        .simultaneousGesture(LongPressGesture(minimumDuration: 0.5).onEnded { _ in
            withAnimation(.spring(response: 0.35, dampingFraction: 0.9)) {
                showShareSheet = true
            }
        })
    }
}

#Preview {
    HomeContainer()
}
