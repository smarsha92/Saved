//
//  SavedLinksView.swift
//  Saved
//
//  Custom view to display saved links from the global savedLinks array
//

import SwiftUI
import SaveIt

struct SavedLinksView: View {
    @State private var savedLinks: [String] = []

    var body: some View {
        ZStack(alignment: .bottom) {
            // List of saved links in the background
            VStack(spacing: 0) {
                if savedLinks.isEmpty {
                    VStack(spacing: 8) {
                        Spacer()
                        Text("No links saved yet")
                            .foregroundColor(.gray)
                            .font(.subheadline)
                        Text("Tap the + button to add a link")
                            .foregroundColor(.gray)
                            .font(.caption)
                        Spacer()
                    }
                } else {
                    List {
                        ForEach(savedLinks.indices, id: \.self) { index in
                            LinkRow(link: savedLinks[index])
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .background(Color(UIColor.systemBackground))

            // Original Home page with FAB button on top
            Pages.Home()
        }
        .onAppear {
            loadSavedLinks()

            // Listen for changes to savedLinks global variable
            Globals.onVariableChange(variable: \.savedLinks) { links in
                if let links = links as? [String] {
                    self.savedLinks = links
                } else if let links = links as? [AnyHashable] {
                    self.savedLinks = links.compactMap { $0 as? String }
                }
            }
        }
        .ignoresSafeArea()
    }

    private func loadSavedLinks() {
        if let links = Globals.getVariable(variable: \.savedLinks) {
            if let links = links as? [String] {
                self.savedLinks = links
            } else if let links = links as? [AnyHashable] {
                self.savedLinks = links.compactMap { $0 as? String }
            }
        }
    }
}

struct LinkRow: View {
    let link: String

    var body: some View {
        HStack {
            Image(systemName: "link.circle.fill")
                .foregroundColor(.blue)
                .font(.title2)

            VStack(alignment: .leading, spacing: 4) {
                Text(link)
                    .font(.body)
                    .lineLimit(2)

                if let url = URL(string: link) {
                    Text(url.host ?? link)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }

            Spacer()

            Button(action: {
                if let url = URL(string: link) {
                    UIApplication.shared.open(url)
                }
            }) {
                Image(systemName: "arrow.up.right.circle")
                    .foregroundColor(.blue)
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    SavedLinksView()
}
