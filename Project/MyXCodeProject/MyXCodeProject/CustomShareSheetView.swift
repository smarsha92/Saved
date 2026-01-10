//
//  CustomShareSheetView.swift
//
//  Created by Play to Xcode
//

import SwiftUI
import UIKit

struct URLShareSheet: View {
    @Binding var urlText: String
    var onSave: () -> Void
    var onCancel: () -> Void

    @FocusState private var isFocused: Bool
    @State private var detectedURL: URL?

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

                    HStack(spacing: 8) {
                        TextField("https://example.com", text: $urlText)
                            .textInputAutocapitalization(.never)
                            .keyboardType(.URL)
                            .autocorrectionDisabled()
                            .focused($isFocused)

                        Button("Paste") {
                            if let pasted = UIPasteboard.general.string {
                                urlText = pasted
                            }
                        }
                        .font(.footnote.weight(.semibold))
                        .buttonStyle(.bordered)
                    }
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(.secondarySystemBackground))
                    )

                    if let detectedURL {
                        HStack(spacing: 8) {
                            Image(systemName: "link")
                                .foregroundStyle(.secondary)
                            Text(detectedURL.absoluteString)
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                                .lineLimit(1)
                                .truncationMode(.middle)
                            Spacer()
                            Button("Use") {
                                urlText = detectedURL.absoluteString
                            }
                            .font(.footnote.weight(.semibold))
                            .buttonStyle(.borderedProminent)
                        }
                        .padding(.top, 4)
                    } else {
                        Button("Detect link from clipboard") {
                            detectedURL = detectURL(in: UIPasteboard.general.string)
                        }
                        .font(.footnote.weight(.semibold))
                        .buttonStyle(.borderless)
                        .foregroundStyle(.secondary)
                        .padding(.top, 4)
                    }
                }

                HStack {
                    Button(action: onSave) {
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
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(Color(.systemBackground))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .stroke(Color(.separator), lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.2), radius: 20, y: 10)
            .padding(.horizontal, 24)
        }
        .onAppear {
            // Focus the text field shortly after presentation for a smoother animation
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                isFocused = true
            }
            detectedURL = detectURL(in: UIPasteboard.general.string)
        }
    }

    private func detectURL(in text: String?) -> URL? {
        guard let text else { return nil }
        let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        let range = NSRange(text.startIndex..<text.endIndex, in: text)
        return detector?.firstMatch(in: text, options: [], range: range)?.url
    }
}
