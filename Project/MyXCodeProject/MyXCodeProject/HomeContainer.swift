//
//  HomeContainer.swift
//
//  Created by Play to Xcode
//

import SwiftUI
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

    // If you have a Play button that should open this sheet, replace the
    // placeholder below with the actual Play ID and uncomment the `.onUpdate`.
    // private let openSheetButtonPlayId = "<replace-with-button-play-id>"

    var body: some View {
        ZStack {
            // Bind the Home text element to our state so it updates live
            Pages.Home()
                .setText(.text1, value: urlText.isEmpty ? "" : urlText)
                .ignoresSafeArea()
                .overlay(alignment: .bottomTrailing) {
                    // Floating Action Button
                    Button(action: {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.9)) {
                            showShareSheet = true
                        }
                    }) {
                        Image(systemName: "plus")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(width: 56, height: 56)
                            .background(Circle().fill(Color.blue))
                            .shadow(color: .black.opacity(0.3), radius: 8, y: 4)
                    }
                    .padding([.bottom, .trailing], 20)
                }

            if showShareSheet {
                URLShareSheet(urlText: $urlText, onSave: {
                    // Dismiss and keep the text (Home already reflects it)
                    withAnimation(.easeInOut) { showShareSheet = false }
                }, onCancel: {
                    // Dismiss without applying changes
                    withAnimation(.easeInOut) { showShareSheet = false }
                })
                .transition(.opacity.combined(with: .scale))
            }
        }
    }
}

#Preview {
    HomeContainer()
}
