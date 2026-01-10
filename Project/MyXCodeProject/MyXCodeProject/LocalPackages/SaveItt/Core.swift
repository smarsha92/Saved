import Foundation
import PlaySDK
import SwiftUI
import UIKit
import SaveItMedia
import SaveItFonts

/// Nested namespacing for ease of use when importing into your app
public enum SaveIt { }

// MARK: Global Runtime Engine
public var RuntimeEngine: PlayRuntimeEngine? = {
    return try? PlayRuntimeEngine.loadingProjectJSON(
        bundle: Bundle.module,
        resource: "project",
        ext: "json",
        assetsBundle: SaveItMedia.getBundle(),
        fontsBundle: SaveItFonts.getBundle(),
        colors: Colors.UIKit.registeredFoundations,
        gradients: Gradients.UIKit.registeredFoundations,
        typography: Typography.registeredFoundations,
        spacing: Spacing.registeredFoundations,
        radius: Radius.registeredFoundations
    )
}()

typealias _State = SwiftUI.State

// MARK: Name spacing for each foundation
public enum Pages {
    public enum UIKit { }
    public enum SwiftUI { }
}

public enum Components {
    public enum UIKit { }
    public enum SwiftUI { }
}

public enum Colors {
    public enum UIKit { }
    public enum SwiftUI { }
}

public enum Gradients {
    public enum UIKit { }
    public enum SwiftUI { }
}

public enum Spacing { }
public enum Typography { }
public enum Radius { }

public enum Images { }
public enum Videos { }
public enum Audio { }
public enum Rive { }
public enum Json { }
public enum Ahap { }
public enum HTML { }

public enum TypeAliases {
    public typealias _Pages = Pages
    public typealias _Components = Components
    public typealias _Colors = Colors
    public typealias _Gradients = Gradients
}

public enum UIK {
    public typealias Pages = TypeAliases._Pages.UIKit
    public typealias Components = TypeAliases._Components.UIKit
    public typealias Colors = TypeAliases._Colors.UIKit
    public typealias Gradients = TypeAliases._Gradients.UIKit
}

public enum SUI {
    public typealias Pages = TypeAliases._Pages.SwiftUI
    public typealias Components = TypeAliases._Components.SwiftUI
    public typealias Colors = TypeAliases._Colors.SwiftUI
    public typealias Gradients = TypeAliases._Gradients.SwiftUI
}

// SwiftUI aliases
extension View {
    public typealias SaveIt = SUI
    public typealias Pages = TypeAliases._Pages.SwiftUI
    public typealias Components = TypeAliases._Components.SwiftUI
    public typealias Colors = SUI.Colors
    public typealias Gradients = SUI.Gradients
}

// UIKit aliases
extension UIResponder {
    public typealias SaveIt = UIK
    public typealias Pages = TypeAliases._Pages.UIKit
    public typealias Components = TypeAliases._Components.UIKit
    public typealias Colors = TypeAliases._Colors.UIKit
    public typealias Gradients = TypeAliases._Gradients.UIKit
}
