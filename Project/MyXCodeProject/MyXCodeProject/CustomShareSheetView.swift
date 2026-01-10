//
//  CustomShareSheetView.swift
//
//  Created by Play to Xcode
//

import SwiftUI

struct URLShareSheet: View {
    var urlText: String
    var onSave: (URL) -> Void
    var onCancel: () -> Void

    @FocusState private var isFocused: Bool
    @State private var draftURL: String
    @State private var showInvalidAlert = false

    init(urlText: String, onSave: @escaping (URL) -> Void, onCancel: @escaping () -> Void) {
        self.urlText = urlText
        self.onSave = onSave
        self.onCancel = onCancel
        _draftURL = State(initialValue: urlText)
    }

    var body: some View {
        ZStack {
            // Dimmed background
            Color.black.opacity(0.35)
                .ignoresSafeArea()

            // Floating card
            VStack(spacing: 16) {
                Text("Save Link")
                    .font(.title3).bold()
                    .frame(maxWidth: .infinity, alignment: .leading)

                VStack(alignment: .leading, spacing: 8) {
                    Text("URL")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    TextField("https://example.com", text: $draftURL)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.URL)
                        .autocorrectionDisabled()
                        .padding(12)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(.secondarySystemBackground))
                        )
                        .focused($isFocused)
                }

                HStack {
                    Button(action: saveURL) {
                        Text("SAVE")
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 12)
                            .background(
                                Capsule().fill(Color.blue)
                            )
                    }

                    Spacer(minLength: 24)

                    Button(action: onCancel) {
                        Text("CANCEL")
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 12)
                            .background(
                                Capsule().fill(Color.red)
                            )
                    }
                }
                .padding(.top, 8)
            }
            .padding(20)
            .background(
                .ultraThinMaterial,
                in: RoundedRectangle(cornerRadius: 24, style: .continuous)
            )
            .shadow(color: Color.black.opacity(0.2), radius: 20, y: 10)
            .padding(.horizontal, 24)
        }
        .onAppear {
            // Focus the text field shortly after presentation for a smoother animation
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                isFocused = true
            }
        }
        .alert("Invalid URL", isPresented: $showInvalidAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Please enter a valid URL, like https://example.com.")
        }
    }

    private func saveURL() {
        let trimmed = draftURL.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let normalizedURL = normalizedURL(from: trimmed) else {
            showInvalidAlert = true
            return
        }
        onSave(normalizedURL)
    }

    private func normalizedURL(from raw: String) -> URL? {
        if let url = URL(string: raw), url.scheme != nil { return url }
        guard raw.isEmpty == false else { return nil }
        return URL(string: "https://\(raw)")
    }
}
