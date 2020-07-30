// Kevin Li - 8:30 PM - 7/29/20

import Foundation

public struct DefaultNodeStyle: NodeStyle {

    public func apply(configuration: Configuration) -> ColorNode {
        configuration.defaultStyledNode
    }

}

public extension NodeStyleConfiguration {

    var defaultStyledNode: ColorNode {
        node
            .scaleFade(!isStartingUp,
                       scale: isPressed ? 0.9 : 1,
                       opacity: isPressed ? 0.3 : 1)
            .highlight(isSelected)
            .focus(isCentered)
            .startUp(isStartingUp)
    }

}
