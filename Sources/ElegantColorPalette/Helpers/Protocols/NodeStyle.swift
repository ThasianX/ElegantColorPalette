// Kevin Li - 8:25 PM - 7/29/20

import Foundation

public protocol NodeStyle {

    typealias Configuration = NodeStyleConfiguration

    @discardableResult
    func apply(configuration: Configuration) -> ColorNode

}
