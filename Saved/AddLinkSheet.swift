//
//  AddLinkSheet.swift
//  Saved
//
//  Sheet for adding new bookmarks with immediate keyboard appearance
//

import SwiftUI

/// A SwiftUI View that presents a sheet interface for adding new bookmarks/links
/// Optimized to show the keyboard immediately when the sheet appears
struct AddLinkSheet: View {

    // MARK: - Properties

    /// Environment property to dismiss the sheet programmatically
    /// Accessed via dismiss() to close the sheet
    @Environment(\.dismiss) private var dismiss

    /// Two-way binding to the text field's content
    /// Allows the parent view to access the entered text and reset it when needed
    @Binding var newLinkText: String

    /// Closure/callback function that executes when the user taps "Save"
    /// The parent view defines what happens when saving (e.g., create bookmark, validate URL)
    let onSave: () -> Void

    /// Focus state that tracks whether the text field is currently focused/active
    /// Used to automatically show the keyboard and prevent accidental dismissal while typing
    @FocusState private var isTextFieldFocused: Bool

    // MARK: - Computed Properties

    /// Determines if the Save button should be disabled
    /// Returns true if the text field is empty or contains only whitespace
    /// This prevents saving invalid/empty bookmarks
    private var isSaveDisabled: Bool {
        newLinkText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    // MARK: - Body

    var body: some View {
        /// NavigationStack provides the navigation bar for title and toolbar buttons
        NavigationStack {
            VStack(spacing: 20) {

                /// Main text input field for entering URLs
                /// This is the primary interaction point for the user
                TextField("Enter URL or website", text: $newLinkText)
                    // Adds rounded border styling to the text field
                    .textFieldStyle(.roundedBorder)

                    // Prevents automatic capitalization of letters (important for URLs)
                    .textInputAutocapitalization(.never)

                    // Disables autocorrection (URLs shouldn't be autocorrected)
                    .autocorrectionDisabled()

                    // Shows URL-optimized keyboard with .com button and forward slash
                    .keyboardType(.URL)

                    // Binds the focus state to this text field
                    // This is the key to controlling keyboard visibility
                    .focused($isTextFieldFocused)

                    // Adds padding around the text field for better touch targets
                    .padding()

                    /// onChange tracks when the user types in the text field
                    /// Can be used for real-time validation, formatting, or other actions
                    .onChange(of: newLinkText) { oldValue, newValue in
                        // Currently no action needed, but available for:
                        // - Auto-formatting URLs (adding https://)
                        // - Real-time validation
                        // - Character filtering
                    }

                /// Helpful example text showing users the expected input format
                /// Reduces user confusion and errors
                Text("Example: apple.com or https://apple.com")
                    .font(.caption)           // Smaller font size
                    .foregroundStyle(.gray)   // Gray color for secondary text

                /// Pushes content to the top of the sheet
                /// Prevents text field from being centered vertically
                Spacer()
            }
            /// Sets the title shown in the navigation bar
            .navigationTitle("Add Bookmark")

            /// Makes the title appear inline (smaller, in the navigation bar)
            /// Saves vertical space for the text field
            .navigationBarTitleDisplayMode(.inline)

            /// Adds toolbar buttons to the navigation bar
            .toolbar {
                /// Cancel button on the left side
                /// Standard iOS placement for cancellation actions
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()  // Closes the sheet without saving
                    }
                }

                /// Save button on the right side
                /// Standard iOS placement for confirmation actions
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        onSave()  // Calls the parent's save function
                    }
                    /// Disables the button when text is empty/whitespace only
                    /// Provides visual feedback about input validity
                    .disabled(isSaveDisabled)
                }
            }
        }
        /// Sets the sheet height to medium (half screen)
        /// Array allows multiple detents for user to resize if needed
        .presentationDetents([.medium])

        /// Shows a visual drag indicator at the top of the sheet
        /// Helps users understand they can drag to dismiss
        .presentationDragIndicator(.visible)

        /// Allows interaction with content behind the sheet up to medium height
        /// User can scroll or tap content behind the sheet while it's open
        .presentationBackgroundInteraction(.enabled(upThrough: .medium))

        /// Prevents accidental dismissal when text field is focused
        /// User must explicitly tap Cancel to dismiss while typing
        /// Protects against losing work if they accidentally swipe down
        .interactiveDismissDisabled(isTextFieldFocused)

        /// CRITICAL: .task is better than .onAppear for focus management
        /// Runs asynchronously, allowing the view hierarchy to fully settle
        /// before focusing the text field
        .task {
            /// Small delay ensures the sheet presentation animation completes
            /// before requesting keyboard focus. This eliminates the visual delay.
            /// 100 milliseconds is imperceptible to users but ensures smooth animation
            try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds

            /// Set focus on the text field
            /// This triggers the keyboard to appear immediately
            isTextFieldFocused = true
        }
    }
}

// MARK: - Preview

/// Preview provider for development and testing
/// Shows how the sheet appears with sample data
#Preview {
    /// Wrapper view to demonstrate the sheet
    struct PreviewWrapper: View {
        @State private var showSheet = true
        @State private var linkText = ""

        var body: some View {
            VStack {
                Text("Tap button to show sheet")
                Button("Show Add Link Sheet") {
                    showSheet = true
                }
            }
            .sheet(isPresented: $showSheet) {
                AddLinkSheet(newLinkText: $linkText) {
                    print("Saved: \(linkText)")
                    showSheet = false
                }
            }
        }
    }

    return PreviewWrapper()
}
