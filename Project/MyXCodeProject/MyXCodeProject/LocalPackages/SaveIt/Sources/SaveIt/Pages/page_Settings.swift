import Foundation
import PlaySDK
import SwiftUI
import UIKit

extension UIK.Pages {
    public class Settings: UIKitBaseViewController<Settings.AvailProps, Settings> {
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
                initialize(engine: RuntimeEngine, playId: "3ecf2aa66ea6d4ACMvJ")
            }
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    @discardableResult public func setVideo(_ element: VideoElement, value: URL?) -> Self {
        Self.setVideo(view: self, elementId: element.playId, value: value)
        return self
    }

    @discardableResult public func setText(_ element: TextElement, value: String?) -> Self {
        Self.setText(view: self, elementId: element.playId, value: value)
        return self
    }

    }
}

extension UIK.Pages.Settings {
    public struct AvailProps { 
        public init() { }
    }

    public enum VideoElement {
        case video1

        var playId: String {
            switch self {
            case .video1:
                return "3ecff2849edceaDvxse"
            }
        }
    }

    public enum TextElement {
        case text1

        var playId: String {
            switch self {
            case .text1:
                return "3ecff39d31b204pG5P9"
            }
        }
    }

}

extension SUI.Pages {
    public struct Settings: SwiftUIBaseViewController {
        public typealias UIViewControllerType = UIK.Pages.Settings
        public typealias ClassType = Self

        public var variables: UIK.Pages.Settings.AvailProps? = .init()
        public var keyPathToPlayId: [AnyHashable: String] = [:]
        public var playIdToUpdateCall: [String : (Any?) -> Void] = [:]
        private var videosToSet: [UIViewControllerType.VideoElement: URL?] = [:]
    private var textToSet: [UIViewControllerType.TextElement: String?] = [:]


        public init() { }

        public func makeUIViewController(context: Context) -> UIViewControllerType {
            return UIViewControllerType()
        }

        public func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            Self.updateUIViewController(uiViewController, suiController: self) { 
        videosToSet.forEach { id, val in
        uiViewController.setVideo(id, value: val)
    }
    textToSet.forEach { id, val in
        uiViewController.setText(id, value: val)
    }

            }
        }
        @discardableResult public func setVideo(_ element: UIViewControllerType.VideoElement, value: URL?) -> Self {
            var mutself = self
            mutself.videosToSet[element] = value
            return mutself
        }

        @discardableResult public func setText(_ element: UIViewControllerType.TextElement, value: String?) -> Self {
            var mutself = self
            mutself.textToSet[element] = value
            return mutself
        }

    }
}
