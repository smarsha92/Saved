import Foundation

/// Model representing a saved link with metadata
public struct LinkItem: Identifiable, Codable, Hashable {
    public let id: UUID
    public let url: String
    public let dateAdded: Date
    public var title: String?
    public var iconURL: String?

    public init(
        id: UUID = UUID(),
        url: String,
        dateAdded: Date = Date(),
        title: String? = nil,
        iconURL: String? = nil
    ) {
        self.id = id
        self.url = url
        self.dateAdded = dateAdded
        self.title = title
        self.iconURL = iconURL
    }

    /// Returns the domain from the URL
    public var domain: String? {
        guard let urlObj = URL(string: url),
              let host = urlObj.host else {
            return nil
        }
        // Remove www. prefix if present
        if host.hasPrefix("www.") {
            return String(host.dropFirst(4))
        }
        return host
    }

    /// Returns a display title (title if available, otherwise domain or URL)
    public var displayTitle: String {
        if let title = title, !title.isEmpty {
            return title
        }
        if let domain = domain {
            return domain
        }
        return url
    }
}

/// Manager for storing and retrieving saved links
public class LinkStorage: ObservableObject {
    @Published public private(set) var links: [LinkItem] = []

    private let userDefaultsKey = "savedLinks"

    public static let shared = LinkStorage()

    private init() {
        loadLinks()
    }

    /// Adds a new link and saves to storage
    public func addLink(_ urlString: String) -> LinkItem? {
        guard let normalizedURL = URLValidator.normalizeURL(urlString) else {
            return nil
        }

        // Check for duplicates
        if links.contains(where: { $0.url == normalizedURL }) {
            return nil
        }

        let newLink = LinkItem(url: normalizedURL)
        links.insert(newLink, at: 0) // Add to beginning
        saveLinks()

        // Sync with Globals
        syncWithGlobals()

        return newLink
    }

    /// Removes a link by ID
    public func removeLink(id: UUID) {
        links.removeAll { $0.id == id }
        saveLinks()
        syncWithGlobals()
    }

    /// Removes a link by URL
    public func removeLink(url: String) {
        links.removeAll { $0.url == url }
        saveLinks()
        syncWithGlobals()
    }

    /// Updates a link's metadata
    public func updateLink(_ link: LinkItem) {
        if let index = links.firstIndex(where: { $0.id == link.id }) {
            links[index] = link
            saveLinks()
        }
    }

    /// Clears all links
    public func clearAll() {
        links.removeAll()
        saveLinks()
        syncWithGlobals()
    }

    // MARK: - Private Methods

    private func loadLinks() {
        guard let data = UserDefaults.standard.data(forKey: userDefaultsKey) else {
            return
        }

        do {
            links = try JSONDecoder().decode([LinkItem].self, from: data)
        } catch {
            print("Failed to load links: \(error)")
        }
    }

    private func saveLinks() {
        do {
            let data = try JSONEncoder().encode(links)
            UserDefaults.standard.set(data, forKey: userDefaultsKey)
        } catch {
            print("Failed to save links: \(error)")
        }
    }

    /// Syncs the links array with the Globals.savedLinks
    private func syncWithGlobals() {
        let urlStrings = links.map { $0.url as AnyHashable? }
        Globals.setVariable(\.savedLinks, value: urlStrings)
    }
}
