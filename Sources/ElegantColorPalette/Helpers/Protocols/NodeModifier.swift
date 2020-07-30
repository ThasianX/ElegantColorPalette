// Kevin Li - 8:25 PM - 7/29/20

import Foundation

public protocol NodeModifier {

    func body(content: Content) -> ColorNode

    /// The color node passed to `body()`.
    typealias Content = ColorNode

}
