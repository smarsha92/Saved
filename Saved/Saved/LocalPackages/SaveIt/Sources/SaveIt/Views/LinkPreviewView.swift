import SwiftUI
import LinkPresentation

/// SwiftUI wrapper for LPLinkView to show rich link previews
public struct LinkPreviewView: UIViewRepresentable {
    let url: URL

    public init(url: URL) {
        self.url = url
    }

    public init?(urlString: String) {
        guard let url = URL(string: urlString) else { return nil }
        self.url = url
    }

    public func makeUIView(context: Context) -> LPLinkView {
        let linkView = LPLinkView(url: url)
        return linkView
    }

    public func updateUIView(_ uiView: LPLinkView, context: Context) {
        // Fetch metadata if not already loaded
        let provider = LPMetadataProvider()
        provider.startFetchingMetadata(for: url) { metadata, error in
            if let metadata = metadata {
                DispatchQueue.main.async {
                    uiView.metadata = metadata
                }
            }
        }
    }
}

/// A more customizable link preview card
public struct LinkPreviewCard: View {
    let urlString: String
    @StateObject private var loader = LinkMetadataLoader()

    public init(urlString: String) {
        self.urlString = urlString
    }

    public var body: some View {
        Group {
            if loader.isLoading {
                loadingView
            } else if let metadata = loader.metadata {
                loadedView(metadata: metadata)
            } else {
                fallbackView
            }
        }
        .onAppear {
            loader.load(urlString: urlString)
        }
    }

    private var loadingView: some View {
        HStack(spacing: 12) {
            ProgressView()
                .frame(width: 60, height: 60)
            VStack(alignment: .leading, spacing: 4) {
                Text("Loading preview...")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text(domain ?? urlString)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
            Spacer()
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }

    private func loadedView(metadata: LinkMetadata) -> some View {
        HStack(spacing: 12) {
            if let imageData = metadata.iconData,
               let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 60, height: 60)
                    .cornerRadius(8)
                    .clipped()
            } else {
                Image(systemName: "link.circle.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.blue)
                    .frame(width: 60, height: 60)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(metadata.title ?? domain ?? "Link")
                    .font(.headline)
                    .lineLimit(2)
                Text(domain ?? urlString)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
            Spacer()
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }

    private var fallbackView: some View {
        HStack(spacing: 12) {
            Image(systemName: "link.circle.fill")
                .font(.system(size: 40))
                .foregroundColor(.blue)
                .frame(width: 60, height: 60)

            VStack(alignment: .leading, spacing: 4) {
                Text(domain ?? "Link")
                    .font(.headline)
                    .lineLimit(1)
                Text(urlString)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
            Spacer()
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }

    private var domain: String? {
        guard let url = URL(string: urlString),
              let host = url.host else { return nil }
        return host.hasPrefix("www.") ? String(host.dropFirst(4)) : host
    }
}

/// Metadata container for link previews
public struct LinkMetadata {
    public let title: String?
    public let iconData: Data?
    public let imageData: Data?
}

/// Loader for fetching link metadata
public class LinkMetadataLoader: ObservableObject {
    @Published public var metadata: LinkMetadata?
    @Published public var isLoading = false
    @Published public var error: Error?

    private var currentURL: String?

    public init() {}

    public func load(urlString: String) {
        guard currentURL != urlString else { return }
        currentURL = urlString

        guard let url = URL(string: urlString) else {
            return
        }

        isLoading = true
        error = nil

        let provider = LPMetadataProvider()
        provider.startFetchingMetadata(for: url) { [weak self] lpMetadata, fetchError in
            DispatchQueue.main.async {
                self?.isLoading = false

                if let fetchError = fetchError {
                    self?.error = fetchError
                    // Still create basic metadata
                    self?.metadata = LinkMetadata(title: nil, iconData: nil, imageData: nil)
                    return
                }

                guard let lpMetadata = lpMetadata else {
                    self?.metadata = LinkMetadata(title: nil, iconData: nil, imageData: nil)
                    return
                }

                // Extract icon data
                var iconData: Data?
                if let iconProvider = lpMetadata.iconProvider {
                    iconProvider.loadDataRepresentation(forTypeIdentifier: "public.image") { data, _ in
                        DispatchQueue.main.async {
                            if let data = data {
                                self?.metadata = LinkMetadata(
                                    title: lpMetadata.title,
                                    iconData: data,
                                    imageData: self?.metadata?.imageData
                                )
                            }
                        }
                    }
                }

                // Set initial metadata with title
                self?.metadata = LinkMetadata(
                    title: lpMetadata.title,
                    iconData: iconData,
                    imageData: nil
                )
            }
        }
    }
}

#Preview("Link Preview Card") {
    VStack(spacing: 16) {
        LinkPreviewCard(urlString: "https://apple.com")
        LinkPreviewCard(urlString: "https://github.com")
    }
    .padding()
}
