import SwiftUI

/// A view for adding new links with URL validation, auto-focus, and link preview
public struct AddLinkView: View {
    /// The text entered in the URL field
    @State private var newLinkText: String = ""

    /// Controls whether the text field is focused (keyboard visible)
    @FocusState private var isTextFieldFocused: Bool

    /// Tracks if the URL is valid for real-time feedback
    @State private var isValidURL: Bool = false

    /// Error message to display for invalid URLs
    @State private var errorMessage: String?

    /// The most recently saved link for showing preview
    @State private var savedLink: LinkItem?

    /// Controls visibility of the link preview
    @State private var showLinkPreview: Bool = false

    /// Callback when a link is successfully saved
    public var onLinkSaved: ((LinkItem) -> Void)?

    /// Callback when the view is dismissed
    public var onDismiss: (() -> Void)?

    /// Reference to link storage
    @ObservedObject private var linkStorage = LinkStorage.shared

    public init(
        onLinkSaved: ((LinkItem) -> Void)? = nil,
        onDismiss: (() -> Void)? = nil
    ) {
        self.onLinkSaved = onLinkSaved
        self.onDismiss = onDismiss
    }

    public var body: some View {
        VStack(spacing: 16) {
            // Header
            headerView

            // URL Input Field
            urlInputField

            // Error message
            if let error = errorMessage {
                Text(error)
                    .font(.caption)
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
            }

            // Link Preview (shown after saving)
            if showLinkPreview, let link = savedLink {
                linkPreviewSection(link: link)
            }

            // Save Button
            saveButton

            Spacer()
        }
        .padding()
        // Step 2: Auto-focus the text field when view appears
        .onAppear {
            // Small delay to ensure view is fully loaded
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                isTextFieldFocused = true
            }
        }
    }

    // MARK: - Subviews

    private var headerView: some View {
        HStack {
            Text("Add Link")
                .font(.title2)
                .fontWeight(.bold)

            Spacer()

            Button(action: {
                onDismiss?()
            }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.title2)
                    .foregroundColor(.secondary)
            }
        }
    }

    /// Main text input field for entering URLs
    /// This is the primary interaction point for the user
    private var urlInputField: some View {
        TextField("Enter URL or website", text: $newLinkText)
            // Adds rounded border styling to the text field
            .textFieldStyle(.roundedBorder)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(borderColor, lineWidth: 2)
            )
            .cornerRadius(8)

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
            .padding(.horizontal)

            // Step 1: Auto-detect valid links using onChange
            .onChange(of: newLinkText) { oldValue, newValue in
                validateURLRealTime(newValue)
            }

            // Handle submit action (when user presses return)
            .onSubmit {
                saveLink()
            }
    }

    /// Dynamic border color based on validation state
    private var borderColor: Color {
        if newLinkText.isEmpty {
            return .clear
        } else if isValidURL {
            return .green
        } else {
            return .red
        }
    }

    private func linkPreviewSection(link: LinkItem) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Link Saved!")
                .font(.subheadline)
                .foregroundColor(.green)
                .fontWeight(.medium)

            // Step 3: Show link preview when saved
            LinkPreviewCard(urlString: link.url)
                .transition(.opacity.combined(with: .move(edge: .top)))
        }
        .padding(.horizontal)
        .animation(.easeInOut(duration: 0.3), value: showLinkPreview)
    }

    private var saveButton: some View {
        Button(action: saveLink) {
            Text("Save Link")
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(isValidURL ? Color.blue : Color.gray)
                .cornerRadius(12)
        }
        .disabled(!isValidURL)
        .padding(.horizontal)
    }

    // MARK: - Methods

    /// Validates the URL in real-time as the user types
    private func validateURLRealTime(_ urlString: String) {
        let trimmed = urlString.trimmingCharacters(in: .whitespacesAndNewlines)

        if trimmed.isEmpty {
            isValidURL = false
            errorMessage = nil
            return
        }

        let result = URLValidator.validate(trimmed)
        isValidURL = result.isValid
        errorMessage = result.isValid ? nil : result.errorMessage
    }

    /// Saves the link if valid
    private func saveLink() {
        let trimmed = newLinkText.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmed.isEmpty else {
            errorMessage = "Please enter a URL"
            return
        }

        let result = URLValidator.validate(trimmed)

        guard result.isValid, let normalizedURL = result.normalizedURL else {
            errorMessage = result.errorMessage
            shakeTextField()
            return
        }

        // Check for duplicates
        if linkStorage.links.contains(where: { $0.url == normalizedURL }) {
            errorMessage = "This link is already saved"
            return
        }

        // Save the link
        if let newLink = linkStorage.addLink(normalizedURL) {
            // Clear input and show preview
            newLinkText = ""
            savedLink = newLink
            showLinkPreview = true
            errorMessage = nil
            isTextFieldFocused = false

            // Notify callback
            onLinkSaved?(newLink)

            // Hide preview after a delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation {
                    showLinkPreview = false
                }
            }
        } else {
            errorMessage = "Failed to save link"
        }
    }

    /// Provides haptic feedback for invalid input
    private func shakeTextField() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
    }
}

// MARK: - Preview

#Preview("Add Link View") {
    AddLinkView(
        onLinkSaved: { link in
            print("Saved: \(link.url)")
        },
        onDismiss: {
            print("Dismissed")
        }
    )
}
