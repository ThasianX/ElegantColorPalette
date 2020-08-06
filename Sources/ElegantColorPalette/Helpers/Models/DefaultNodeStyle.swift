// Kevin Li - 8:30 PM - 7/29/20

import Foundation

/// The default node style.
public struct DefaultNodeStyle: NodeStyle {

    /// Creates a default button style.
    public init() {}

    /// Updates a `ColorNode` based on the `Configuration`.
    ///
    /// - Parameter configuration: The properties of the `ColorNode` instance being
    ///   updated.
    ///
    /// This method will be called for each instance of `ColorNode` created within
    /// a view hierarchy where this style is the current `NodeStyle`.
    public func updateNode(configuration: Configuration) -> ColorNode {
        configuration.defaultStyledNode
    }

}

public extension NodeStyleConfiguration {

    /// The `ColorNode` with default styling applied.
    ///
    /// Use this in your `NodeStyle` if you want to add on to existing styling.
    var defaultStyledNode: ColorNode {
        node
            .scaleFade(!isFirstShown,
                       scale: isPressed ? 0.9 : (isFocusing ? 1.2 : 1),
                       opacity: isPressed ? 0.3 : 1)
            .highlight(isSelected)
            .label(isFocused)
            .startUp(isFirstShown)
    }

}
