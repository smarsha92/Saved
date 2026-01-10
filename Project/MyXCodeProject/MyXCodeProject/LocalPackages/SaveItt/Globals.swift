import PlaySDK
import UIKit

// Global variables
public var Globals: InnerGlobal = .init()

public class InnerGlobal {
    private var _innerGlobal: GlobalObject<AvailProps> = .init(RuntimeEngine)
    
    private var _customVariableChange: [String: (Any?) -> Void] = [:]
    
    init() {
        _innerGlobal.setKeyPathToPlayId([
            \AvailProps.linkList: "3ecf3d5e5b5e8ahhPXJ",
            \AvailProps.newLinkInput: "3ecf3d77e4b048DVwnV",
            \AvailProps.currentTab: "3ecfde9dd6ac42c9cQ3",
        ])
    }
    
    /// Executes the callback when the variable changes. Only one callback can be set per variable. If there is an existing callback on a given variable and you call this function, it will replace the previous callback.
    @discardableResult public func onVariableChange<ValueType>(variable: KeyPath<AvailProps, ValueType>, _ callback: ((_ val: ValueType) -> Void)?) -> Self {
        _innerGlobal.onVariableChange(variable: variable, callback)
        return self
    }
    
    @discardableResult public func setVariable<ValueType>(_ variable: KeyPath<AvailProps, ValueType>, value: ValueType) -> Self {
        guard let playId = _innerGlobal.keyPathToPlayId[variable] else { return self }
        _innerGlobal.setVariable(id: playId, val: value)
        return self
    }
    
    public func getVariable<ValueType>(variable: KeyPath<AvailProps, ValueType>) -> ValueType? {
        guard let playId = _innerGlobal.keyPathToPlayId[variable] else { return nil }
        return _innerGlobal.getVariable(id: playId) as? ValueType
    }
}

extension InnerGlobal {
    public struct AvailProps {
        public var linkList: [AnyHashable?]?
        public var newLinkInput: String?
        public var currentTab: CGFloat?

        public init() { }
    }
}