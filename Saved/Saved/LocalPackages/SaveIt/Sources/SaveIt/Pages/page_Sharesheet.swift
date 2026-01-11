import Foundation
import PlaySDK
import SwiftUI
import UIKit

extension UIK.Pages {
    public class Sharesheet: UIKitBaseViewController<Sharesheet.AvailProps, Sharesheet> {
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
                initialize(engine: RuntimeEngine, playId: "3ecf4069dfd02egjJuP")
            }
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}

extension UIK.Pages.Sharesheet {
    public struct AvailProps { 
        public init() { }
    }
}

extension SUI.Pages {
    public struct Sharesheet: SwiftUIBaseViewController {
        public typealias UIViewControllerType = UIK.Pages.Sharesheet
        public typealias ClassType = Self

        public var variables: UIK.Pages.Sharesheet.AvailProps? = .init()
        public var keyPathToPlayId: [AnyHashable: String] = [:]
        public var playIdToUpdateCall: [String : (Any?) -> Void] = [:]
    

        public init() { }

        public func makeUIViewController(context: Context) -> UIViewControllerType {
            return UIViewControllerType()
        }

        public func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            Self.updateUIViewController(uiViewController, suiController: self) { 
    
            }
        }
    }
}
