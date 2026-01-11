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

    }
}

extension UIK.Pages.Home {
    public struct AvailProps { 
        public init() { }
    }

    public enum TextElement {
        case urls

        var playId: String {
            switch self {
            case .urls:
                return "3ed0cebcdd5924LgOBd/3ed0cf6c2732b2DOtkJ"
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

    }
}
