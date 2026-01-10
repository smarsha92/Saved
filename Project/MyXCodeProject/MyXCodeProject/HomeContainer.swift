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
    private let savedLinksDefaultsKey = "UIK.Pages.Home.savedMainScreenLinks"

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
                    let urlString = normalizedURL.absoluteString
                    saveLink(urlString)
                    applySavedLink(urlString)
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
        .onAppear {
            loadSavedLink()
        }
        .onReceive(NotificationCenter.default.publisher(for: .savedMainScreenLinksDidChange)) { _ in
            loadSavedLink()
        }
    }

    private func loadSavedLink() {
        let links = UserDefaults.standard.stringArray(forKey: savedLinksDefaultsKey) ?? []
        guard let latest = links.last else {
            urlText = ""
            savedURL = nil
            return
        }
        applySavedLink(latest)
    }

    private func saveLink(_ urlString: String) {
        var links = UserDefaults.standard.stringArray(forKey: savedLinksDefaultsKey) ?? []
        if links.contains(urlString) == false {
            links.append(urlString)
            UserDefaults.standard.set(links, forKey: savedLinksDefaultsKey)
        }
        NotificationCenter.default.post(name: .savedMainScreenLinksDidChange, object: nil)
    }

    private func applySavedLink(_ urlString: String) {
        urlText = urlString
        savedURL = URL(string: urlString)
    }
}

#Preview {
    HomeContainer()
}
