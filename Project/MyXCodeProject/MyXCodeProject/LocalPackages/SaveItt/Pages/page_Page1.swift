import Foundation
import PlaySDK
import SwiftUI
import UIKit

extension UIK.Pages {
    public class Page1: UIKitBaseViewController<Page1.AvailProps, Page1> {
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
                initialize(engine: RuntimeEngine, playId: "3ecf274eaea1f4OxvTH")
            }
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    @discardableResult public func setImage(_ element: ImageElement, value: UIImage?) -> Self {
        Self.setImage(view: self, elementId: element.playId, value: value)
        return self
    }

    @discardableResult public func setText(_ element: TextElement, value: String?) -> Self {
        Self.setText(view: self, elementId: element.playId, value: value)
        return self
    }

    }
}

extension UIK.Pages.Page1 {
    public struct AvailProps { 
        public init() { }
    }

    public enum ImageElement {
        case image1

        var playId: String {
            switch self {
            case .image1:
                return "3ecff0bb4e791eQImDD"
            }
        }
    }

    public enum TextElement {
        case text1

        var playId: String {
            switch self {
            case .text1:
                return "3ecfeb2082e032sAxHr"
            }
        }
    }

}

extension SUI.Pages {
    public struct Page1: SwiftUIBaseViewController {
        public typealias UIViewControllerType = UIK.Pages.Page1
        public typealias ClassType = Self

        public var variables: UIK.Pages.Page1.AvailProps? = .init()
        public var keyPathToPlayId: [AnyHashable: String] = [:]
        public var playIdToUpdateCall: [String : (Any?) -> Void] = [:]
        private var imagesToSet: [UIViewControllerType.ImageElement: UIImage?] = [:]
    private var textToSet: [UIViewControllerType.TextElement: String?] = [:]


        public init() { }

        public func makeUIViewController(context: Context) -> UIViewControllerType {
            return UIViewControllerType()
        }

        public func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            Self.updateUIViewController(uiViewController, suiController: self) { 
        imagesToSet.forEach { id, val in
        uiViewController.setImage(id, value: val)
    }
    textToSet.forEach { id, val in
        uiViewController.setText(id, value: val)
    }

            }
        }
        @discardableResult public func setImage(_ element: UIViewControllerType.ImageElement, value: UIImage?) -> Self {
            var mutself = self
            mutself.imagesToSet[element] = value
            return mutself
        }

        @discardableResult public func setText(_ element: UIViewControllerType.TextElement, value: String?) -> Self {
            var mutself = self
            mutself.textToSet[element] = value
            return mutself
        }

    }
}
