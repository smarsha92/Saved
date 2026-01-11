import Foundation
import UIKit
import SwiftUI

// MARK: Colors
extension Colors.UIKit {
    // Registered from play
    static var registeredFoundations: [String: UIColor] = [
        "3ecf2cbdb6f3d04X8Th": untitledColor,
    ]

    public static let untitledColor: UIColor = Self.themed(playId: "3ecf2cbdb6f3d04X8Th", light: .init(red: 0.561158477282915, green: 0.28999782977928695, blue: 0.28999782977928695, alpha: 1.0))

    /// Helper for light/dark mode
    static func themed(playId: String, light: UIColor, dark: UIColor? = nil) -> UIColor {
        return UIColor(dynamicProvider: { ($0.userInterfaceStyle == .dark) ? dark ?? light : light })
    }
}

extension Colors.SwiftUI { 
    public static let untitledColor: Color = .init(uiColor: Colors.UIKit.untitledColor)
}
