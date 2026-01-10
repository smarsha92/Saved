import Foundation
import PlaySDK
import SwiftUI
import UIKit

extension UIK.Components {
    public class TextField1: UIKitBaseView<TextField1.AvailProps, TextField1> {
        override public var variables: AvailProps? { _variables }
        public var state: State { Self.getState(Self.getCurrentState(view: self)) ?? .defaultState }

        private var _variables: AvailProps = .init()

        override public var keyPathToPlayId: [AnyHashable: String] {
            get { _keyPathToPlayId }
            set { _keyPathToPlayId = newValue }
        }
        private var _keyPathToPlayId: [AnyHashable: String] = [:]
        
        convenience public init() {
            self.init(frame: .zero)
        }

        override public init(frame: CGRect) {
            super.init(frame: frame)
            if let RuntimeEngine {
                initialize(engine: RuntimeEngine, playId: "3ecf22ac794a3aAmY47")
            }
        }

        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        @discardableResult public func state(_ state: State, runLayout: Bool = false) -> Self {
            Self.setState(view: self, stateId: state.playId, runLayout: runLayout)
            return self
        }
    }
}

extension UIK.Components.TextField1 {
    public struct AvailProps { 
        public init() { }
    }
    public enum State {
        case defaultState

        var playId: String {
            switch self {
            case .defaultState:
                return "default"

            }
        }
    }

    private static func getState(_ playId: String) -> State? {
        switch playId {
        case "default":
            return .defaultState

        default:
            return nil
        }
    }
}


extension SUI.Components {
    public struct TextField1: SwiftUIBaseView {
        public typealias State = UIViewType.State
        public typealias ClassType = Self

        @_State var layoutSize: CGSize = .zero
        @Binding var state: UIK.Components.TextField1.State?

        public var variables: UIK.Components.TextField1.AvailProps? = .init()
        public var keyPathToPlayId: [AnyHashable: String] = [:]
        public var playIdToUpdateCall: [String : (Any?) -> Void] = [:]

        private var onStateChange: ((State, Animation?) -> Void)?
    
        public init() {
            self._state = .constant(nil)
        }

        public func makeUIView(context: Context) -> UIK.Components.TextField1 {
            let view = UIViewType().isSwiftUI(true).state(state ?? .defaultState)
            view.triggerLoadEvent()
            return view
        }

        public func updateUIView(_ uiView: UIK.Components.TextField1, context: Context) {
            Self.updateUIView(uiView, suiView: self) { 

                // SwiftUI hack to get view to request size again
                let _ = layoutSize

                if let state,
                   uiView.state != state
                {
                    if let ani = context.transaction.animation {
                        uiView.onResize = nil
                        uiView.onStateChange = nil
                        let caAni = Self.getCAAnimation(ani) ?? .init()

                        if let caAni = caAni as? CASpringAnimation {
                            UIView.animate(withDuration: caAni.duration, delay: 0, usingSpringWithDamping: caAni.damping, initialSpringVelocity: caAni.initialVelocity) {
                                CATransaction.begin()
                                CATransaction.setAnimationTimingFunction(caAni.timingFunction)
                                uiView.state(state, runLayout: true)
                                CATransaction.commit()
                            }
                        } else {
                            UIView.animate(withDuration: caAni.duration, delay: 0, options: []) {
                                CATransaction.begin()
                                CATransaction.setAnimationTimingFunction(caAni.timingFunction)
                                uiView.state(state, runLayout: true)
                                CATransaction.commit()
                            }
                        }
                    } else {
                        uiView.state(state)
                    }
                }

                uiView.onResize = { size, ani in
                    if let ani {
                        withAnimation(ani) {
                            layoutSize = size
                        }
                    } else {
                        layoutSize = size
                    }
                }

                uiView.onStateChange = { [weak uiView] ani in
                    guard let uiView else { return }
                    if let ani {
                        withAnimation(ani) {
                            state = uiView.state
                        }
                    } else {
                        state = uiView.state
                    }
                    onStateChange?(uiView.state, ani)
                }
            }
        }

        public func sizeThatFits(_ proposal: ProposedViewSize, uiView: UIK.Components.TextField1, context: Context) -> CGSize? {
            var rSize: CGSize = uiView.nodeView.frame.size
            if !uiView.isWidthFixedValue, let val = proposal.width {
                rSize.width = val
            }
            if !uiView.isHeightFixedValue, let val = proposal.height {
                rSize.height = val
            }
            return rSize
        }

        @discardableResult public func state(_ state: Binding<State?>) -> Self {
            var mutSelf = self
            mutSelf._state = state
            return mutSelf
        }

        @discardableResult public func onStateChange(_ callback: @escaping ((State, Animation?) -> Void)) -> Self {
            var mutself =  self
            mutself.onStateChange = callback
            return mutself
        }
    }
}

extension View {
    public typealias TextField1 = SUI.Components.TextField1
}

extension UIResponder {
    public typealias TextField1 = UIK.Components.TextField1
}

