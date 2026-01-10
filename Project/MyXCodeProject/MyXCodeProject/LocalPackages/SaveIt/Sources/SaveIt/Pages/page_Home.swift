import Foundation
import PlaySDK
import SwiftUI
import UIKit

extension UIK.Pages {
    public class Home: UIKitBaseViewController<Home.AvailProps, Home> {
        override public var variables: AvailProps? { _variables }
        private var _variables: AvailProps = .init()

        override public var keyPathToPlayId: [AnyHashable: String] {
            get { _keyPathToPlayId }
            set { _keyPathToPlayId = newValue }
        }
        private var _keyPathToPlayId: [AnyHashable: String] = [:]

        public convenience init() {
            self.init(nibName: nil, bundle: nil)
        }

        public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
            super.init(nibName: nil, bundle: nil)
            if let RuntimeEngine {
                initialize(engine: RuntimeEngine, playId: "3ecf18518ba7e41oyse")
            }
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    @discardableResult public func setText(_ element: TextElement, value: String?) -> Self {
        Self.setText(view: self, elementId: element.playId, value: value)
        return self
    }

    // Presents options to share a URL, open in Safari, or save to the app's main screen
    public func presentShareOptions(for url: URL, sourceView: UIView? = nil) {
        let alert = UIAlertController(title: "Share Link", message: nil, preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "Save to Main Screen", style: .default, handler: { [weak self] _ in
            self?.saveLinkToMainScreen(url)
        }))

        alert.addAction(UIAlertAction(title: "Save a Different Link…", style: .default, handler: { [weak self] _ in
            self?.presentSaveLinkPrompt(prefilled: nil)
        }))

        alert.addAction(UIAlertAction(title: "Open in Safari (Add to Home Screen)", style: .default, handler: { _ in
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }))

        alert.addAction(UIAlertAction(title: "Share Link…", style: .default, handler: { [weak self] _ in
            self?.presentShareSheet(for: url, sourceView: sourceView)
        }))

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        if let pop = alert.popoverPresentationController {
            pop.sourceView = sourceView ?? self.view
            pop.sourceRect = sourceView?.bounds ?? CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 1, height: 1)
            pop.permittedArrowDirections = sourceView == nil ? [] : .any
        }

        self.present(alert, animated: true)
    }

    /// Prompts the user to enter a URL to save to the main screen
    public func presentSaveLinkPrompt(prefilled: String?) {
        let alert = UIAlertController(title: "Save Link", message: "Enter a URL to save to the main screen.", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "https://example.com"
            textField.keyboardType = .URL
            textField.autocapitalizationType = .none
            textField.autocorrectionType = .no
            textField.text = prefilled
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let save = UIAlertAction(title: "Save", style: .default) { [weak self, weak alert] _ in
            guard let self = self,
                  let text = alert?.textFields?.first?.text?.trimmingCharacters(in: .whitespacesAndNewlines),
                  let normalized = self.normalizedURL(from: text) else {
                self?.presentSimpleInfoAlert(title: "Invalid URL", message: "Please enter a valid URL, e.g., https://example.com")
                return
            }
            self.saveLinkToMainScreen(normalized)
        }
        alert.addAction(cancel)
        alert.addAction(save)
        self.present(alert, animated: true)
    }

    /// Attempt to normalize a user-entered URL string into a valid URL (adds https scheme if missing)
    private func normalizedURL(from raw: String) -> URL? {
        if let url = URL(string: raw), url.scheme != nil { return url }
        // Prepend https if no scheme
        let withScheme = "https://" + raw
        return URL(string: withScheme)
    }

    /// Simple info alert helper
    private func presentSimpleInfoAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }

    // MARK: - In-app "Main Screen" link persistence
    private var savedLinksDefaultsKey: String { "UIK.Pages.Home.savedMainScreenLinks" }

    /// Save a URL to the app's main screen list (UserDefaults-backed)
    public func saveLinkToMainScreen(_ url: URL) {
        var links = fetchSavedMainScreenLinks()
        let urlString = url.absoluteString
        if links.contains(urlString) == false {
            links.append(urlString)
            UserDefaults.standard.set(links, forKey: savedLinksDefaultsKey)
        }
        NotificationCenter.default.post(name: .savedMainScreenLinksDidChange, object: self)
    }

    /// Fetch saved links intended for the app's main screen
    public func fetchSavedMainScreenLinks() -> [String] {
        UserDefaults.standard.stringArray(forKey: savedLinksDefaultsKey) ?? []
    }

    /// Remove a saved link (helper)
    public func removeSavedMainScreenLink(_ urlString: String) {
        var links = fetchSavedMainScreenLinks()
        if let idx = links.firstIndex(of: urlString) {
            links.remove(at: idx)
            UserDefaults.standard.set(links, forKey: savedLinksDefaultsKey)
            NotificationCenter.default.post(name: .savedMainScreenLinksDidChange, object: self)
        }
    }

    /// Presents a standard share sheet for a URL
    public func presentShareSheet(for url: URL, sourceView: UIView? = nil) {
        let activity = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        if let pop = activity.popoverPresentationController {
            pop.sourceView = sourceView ?? self.view
            pop.sourceRect = sourceView?.bounds ?? CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 1, height: 1)
            pop.permittedArrowDirections = sourceView == nil ? [] : .any
        }
        self.present(activity, animated: true)
    }
    }
}

extension UIK.Pages.Home {
    public struct AvailProps { 
        public init() { }
    }

    public enum TextElement {
        case text1

        var playId: String {
            switch self {
            case .text1:
                return "3ecff821dea328stdGI"
            }
        }
    }

}

extension SUI.Pages {
    public struct Home: SwiftUIBaseViewController {
        public typealias UIViewControllerType = UIK.Pages.Home
        public typealias ClassType = Self

        public var variables: UIK.Pages.Home.AvailProps? = .init()
        public var keyPathToPlayId: [AnyHashable: String] = [:]
        public var playIdToUpdateCall: [String : (Any?) -> Void] = [:]
        private var textToSet: [UIViewControllerType.TextElement: String?] = [:]


        public init() { }

        public func makeUIViewController(context: Context) -> UIViewControllerType {
            return UIViewControllerType()
        }

        public func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            Self.updateUIViewController(uiViewController, suiController: self) { 
        textToSet.forEach { id, val in
        uiViewController.setText(id, value: val)
    }

            }
        }
        @discardableResult public func setText(_ element: UIViewControllerType.TextElement, value: String?) -> Self {
            var mutself = self
            mutself.textToSet[element] = value
            return mutself
        }

        // Present the in-app save link prompt
        public func presentSaveLinkPrompt(in uiViewController: UIViewControllerType, prefilled: String? = nil) {
            uiViewController.presentSaveLinkPrompt(prefilled: prefilled)
        }

    }
}

extension Notification.Name {
    static let savedMainScreenLinksDidChange = Notification.Name("savedMainScreenLinksDidChange")
}
