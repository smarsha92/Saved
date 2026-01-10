import Foundation
import UIKit

extension Images {

    public static let frame2xpng_2: ImageAsset = .init(playId: "3ecff0b4c1432cBMvFa")
    public static let frame2xpng: ImageAsset = .init(playId: "3ecff0a5aa20f4bLIjk")
    public static let frame2xpng_1: ImageAsset = .init(playId: "3ecff0bb4e470azdSMY")
}

public class ImageAsset {
    var playId: String

    init(playId: String) {
        self.playId = playId
    }

    public var uiImage: UIImage {
        if let _uiImage { return _uiImage }
        let img: UIImage = RuntimeEngine?.getImageAssetUIImage(playId: playId) ?? .init()
        _uiImage = img
        return img
    }
    weak private var _uiImage: UIImage?
}
