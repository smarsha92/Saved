import Foundation

public class GeneralAsset {
    var playId: String

    init(playId: String) {
        self.playId = playId
    }

    public var url: URL {
        return RuntimeEngine?.getAssetUrl(playId: playId) ?? .init(fileURLWithPath: "")
    }
}
