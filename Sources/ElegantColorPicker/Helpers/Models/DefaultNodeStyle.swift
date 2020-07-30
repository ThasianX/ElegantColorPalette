// Kevin Li - 8:30 PM - 7/29/20

import Foundation

public struct DefaultNodeStyle: NodeStyle {

    public func apply(configuration: Configuration) -> ColorNode {
        configuration.node
            .scaleFade(!configuration.isStartingUp,
                       scale: configuration.isPressed ? 0.9 : 1,
                       opacity: configuration.isPressed ? 0.3 : 1)
            .highlight(configuration.isSelected)
            .focus(configuration.isCentered)
            .startUp(configuration.isStartingUp)
    }

}
