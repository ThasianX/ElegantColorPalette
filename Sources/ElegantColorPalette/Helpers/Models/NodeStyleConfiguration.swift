// Kevin Li - 8:26 PM - 7/29/20

import Foundation

/// The properties of a `ColorNode` instance being updated.
public struct NodeStyleConfiguration {

    /// The `ColorNode` associated with the given state changes.
    public let node: ColorNode

    /// Whether or not the node is currently being first shown.
    public var isFirstShown: Bool

    /// Whether or not the node is currently being pressed down by the user.
    public let isPressed: Bool

    /// Whether or not the node matches the selected `PaletteColor`.
    public let isSelected: Bool

    /// Whether or not the node is currently in the process of moving towards
    /// its focused location.
    public let isFocusing: Bool

    /// Whether or not the node is currently focused.
    ///
    /// Focused means that this node is the node the user most recently tapped on
    /// and it has arrived at its focus location.
    public let isFocused: Bool

}

extension NodeStyleConfiguration {

    static func firstShown(_ node: ColorNode, isSelected: Bool) -> NodeStyleConfiguration {
        NodeStyleConfiguration(node: node,
                               isFirstShown: true,
                               isPressed: false,
                               isSelected: isSelected,
                               isFocusing: false,
                               isFocused: false)
    }

    static func touchedDown(_ node: ColorNode, isSelected: Bool, isFocused: Bool) -> NodeStyleConfiguration {
        NodeStyleConfiguration(node: node,
                               isFirstShown: false,
                               isPressed: true,
                               isSelected: isSelected,
                               isFocusing: false,
                               isFocused: isFocused)
    }

    static func touchedUp(_ node: ColorNode, isSelected: Bool, isFocused: Bool) -> NodeStyleConfiguration {
        NodeStyleConfiguration(node: node,
                               isFirstShown: false,
                               isPressed: false,
                               isSelected: isSelected,
                               isFocusing: true,
                               isFocused: isFocused)
    }

    static func unselected(_ node: ColorNode) -> NodeStyleConfiguration {
        NodeStyleConfiguration(node: node,
                               isFirstShown: false,
                               isPressed: false,
                               isSelected: false,
                               isFocusing: false,
                               isFocused: false)
    }

    static func selectedAndFocused(_ node: ColorNode) -> NodeStyleConfiguration {
        NodeStyleConfiguration(node: node,
                               isFirstShown: false,
                               isPressed: false,
                               isSelected: true,
                               isFocusing: false,
                               isFocused: true)
    }

}
