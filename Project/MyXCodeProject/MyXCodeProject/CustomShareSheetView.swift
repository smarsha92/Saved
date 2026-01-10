//
//  CustomShareSheetView.swift
//
//  Created by Play to Xcode
//

import SwiftUI

struct URLShareSheet: View {
    @Binding var urlText: String
    var onSave: () -> Void
    var onCancel: () -> Void

    @FocusState private var isFocused: Bool

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

                    TextField("https://example.com", text: $urlText)
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
    }
}
