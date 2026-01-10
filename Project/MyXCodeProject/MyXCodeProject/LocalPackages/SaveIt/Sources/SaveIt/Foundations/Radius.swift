import Foundation
import UIKit

extension Radius {
    // Registered from play
    static var registeredFoundations: [String: CGFloat] = [
        "zeroCornerRadius": _0,
        "fourCornerRadius": _4,
        "eightCornerRadius": _8,
        "twelveCornerRadius": _12,
        "wentyFourCornerRadius": _24,
        "sixteenCornerRadius": _16,
        "thirtyTwoCornerRadius": _32,
        "fortyEightCornerRadius": _48,
        "fiftySixCornerRadius": _56,
        "fortyCornerRadius": _40,
        "sixtyFourCornerRadius": _64,
    ]

    public static let _0: CGFloat = 0.0
    public static let _4: CGFloat = 4.0
    public static let _8: CGFloat = 8.0
    public static let _12: CGFloat = 12.0
    public static let _24: CGFloat = 24.0
    public static let _16: CGFloat = 16.0
    public static let _32: CGFloat = 32.0
    public static let _48: CGFloat = 48.0
    public static let _56: CGFloat = 56.0
    public static let _40: CGFloat = 40.0
    public static let _64: CGFloat = 64.0
}
