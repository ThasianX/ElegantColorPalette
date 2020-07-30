// Kevin Li - 8:30 PM - 7/29/20

import Foundation

public struct DefaultNodeStyle: NodeStyle {

    public func apply(configuration: Configuration) -> ColorNode {
        configuration.node
            .highlight(configuration.isSelected)
            .scaleFade(!configuration.isStartingUp, scale: configuration.isPressed ? 0.9 : 1,
                       opacity: configuration.isPressed ? 0.3 : 1)
            .focus(configuration.isCentered)
    }

}
