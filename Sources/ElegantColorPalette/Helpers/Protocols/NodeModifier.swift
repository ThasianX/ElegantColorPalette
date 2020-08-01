// Kevin Li - 8:25 PM - 7/29/20

import Foundation

/// A modifier that can be applied to a `ColorNode` or other `NodeModifier`,
/// producing a different version of the original value.
public protocol NodeModifier {

    /// Returns the current body of `self`. `content` is a proxy for
    /// the `ColorNode` that will have the modifier represented by `Self`
    /// applied to it.
    func body(content: Content) -> ColorNode

    /// The color node passed to `body()`.
    typealias Content = ColorNode

}
