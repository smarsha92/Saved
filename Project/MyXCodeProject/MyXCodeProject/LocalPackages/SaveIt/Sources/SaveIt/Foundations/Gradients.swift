import SwiftUI
import PlaySDK

extension Gradients.UIKit {
    // Registered from play
    static var registeredFoundations: [String: PlayGradient] = [:]
}

extension Gradients.SwiftUI { }

struct _Gradient: UIViewRepresentable {
    let info: PlayGradient
    public init(_ gradient: PlayGradient) {
        info = gradient
    }

    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        info.applyTo(view)
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) { }
}
