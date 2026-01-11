import SwiftUI

/// A view that displays a list of saved links with previews
public struct SavedLinksListView: View {
    @ObservedObject private var linkStorage = LinkStorage.shared

    /// Callback when a link is tapped
    public var onLinkTapped: ((LinkItem) -> Void)?

    public init(onLinkTapped: ((LinkItem) -> Void)? = nil) {
        self.onLinkTapped = onLinkTapped
    }

    public var body: some View {
        Group {
            if linkStorage.links.isEmpty {
                emptyStateView
            } else {
                linksList
            }
        }
    }

    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "link.circle")
                .font(.system(size: 60))
                .foregroundColor(.secondary)

            Text("No links saved yet")
                .font(.headline)
                .foregroundColor(.secondary)

            Text("Add your first link to get started")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var linksList: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(linkStorage.links) { link in
                    LinkRow(link: link, onTap: {
                        onLinkTapped?(link)
                        openURL(link.url)
                    }, onDelete: {
                        withAnimation {
                            linkStorage.removeLink(id: link.id)
                        }
                    })
                }
            }
            .padding()
        }
    }

    private func openURL(_ urlString: String) {
        guard let url = URL(string: urlString) else { return }
        UIApplication.shared.open(url)
    }
}

/// A row displaying a single saved link with preview
public struct LinkRow: View {
    let link: LinkItem
    var onTap: (() -> Void)?
    var onDelete: (() -> Void)?

    @State private var showingDeleteConfirmation = false

    public init(
        link: LinkItem,
        onTap: (() -> Void)? = nil,
        onDelete: (() -> Void)? = nil
    ) {
        self.link = link
        self.onTap = onTap
        self.onDelete = onDelete
    }

    public var body: some View {
        Button(action: { onTap?() }) {
            LinkPreviewCard(urlString: link.url)
        }
        .buttonStyle(.plain)
        .contextMenu {
            Button(action: { onTap?() }) {
                Label("Open Link", systemImage: "safari")
            }

            Button(action: copyLink) {
                Label("Copy Link", systemImage: "doc.on.doc")
            }

            Button(action: shareLink) {
                Label("Share", systemImage: "square.and.arrow.up")
            }

            Divider()

            Button(role: .destructive, action: { showingDeleteConfirmation = true }) {
                Label("Delete", systemImage: "trash")
            }
        }
        .confirmationDialog(
            "Delete this link?",
            isPresented: $showingDeleteConfirmation,
            titleVisibility: .visible
        ) {
            Button("Delete", role: .destructive) {
                onDelete?()
            }
            Button("Cancel", role: .cancel) {}
        }
    }

    private func copyLink() {
        UIPasteboard.general.string = link.url
    }

    private func shareLink() {
        guard let url = URL(string: link.url) else { return }
        let activityVC = UIActivityViewController(
            activityItems: [url],
            applicationActivities: nil
        )

        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first,
           let rootVC = window.rootViewController {
            rootVC.present(activityVC, animated: true)
        }
    }
}

#Preview("Saved Links List") {
    SavedLinksListView(onLinkTapped: { link in
        print("Tapped: \(link.url)")
    })
}
