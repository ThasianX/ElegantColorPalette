// Kevin Li - 8:25 PM - 7/29/20

import Foundation

/// Defines the implementation of all `ColorNoe` instances within a view
/// hierarchy.
///
/// To configure the current `NodeStyle` for a view hiearchy, use the
/// `.nodeStyle()` modifier.
///
/// `ColorNode` instances built using a `NodeStyle` will use custom
/// interaction behavior.
public protocol NodeStyle {

    /// The properties of a `ColorNode` instance being created.
    typealias Configuration = NodeStyleConfiguration

    /// Updates a `ColorNode` based on the `Configuration`.
    ///
    /// - Parameter configuration: The properties of the `ColorNode` instance being
    ///   updated.
    ///
    /// This method will be called for each instance of `ColorNode` created within
    /// a view hierarchy where this style is the current `NodeStyle`.
    @discardableResult
    func updateNode(configuration: Configuration) -> ColorNode

}
