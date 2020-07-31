// Kevin Li - 8:26 PM - 7/29/20

import Foundation

public struct NodeStyleConfiguration {

    public let node: ColorNode
    public var isStartingUp: Bool
    public let isPressed: Bool
    public let isSelected: Bool
    public let isCentered: Bool

}

extension NodeStyleConfiguration {

    static func startUp(_ node: ColorNode, isSelected: Bool) -> NodeStyleConfiguration {
        NodeStyleConfiguration(node: node, isStartingUp: true, isPressed: false, isSelected: isSelected, isCentered: false)
    }

    static func touchedDown(_ node: ColorNode, isSelected: Bool, isCentered: Bool) -> NodeStyleConfiguration {
        NodeStyleConfiguration(node: node, isStartingUp: false, isPressed: true, isSelected: isSelected, isCentered: isCentered)
    }

    static func touchedUp(_ node: ColorNode, isSelected: Bool, isCentered: Bool) -> NodeStyleConfiguration {
        NodeStyleConfiguration(node: node, isStartingUp: false, isPressed: false, isSelected: isSelected, isCentered: isCentered)
    }

    static func selectedNotCentered(_ node: ColorNode) -> NodeStyleConfiguration {
        NodeStyleConfiguration(node: node, isStartingUp: true, isPressed: false, isSelected: true, isCentered: false)
    }

    static func unselected(_ node: ColorNode) -> NodeStyleConfiguration {
        NodeStyleConfiguration(node: node, isStartingUp: false, isPressed: false, isSelected: false, isCentered: false)
    }

    static func selectedAndCentered(_ node: ColorNode) -> NodeStyleConfiguration {
        NodeStyleConfiguration(node: node, isStartingUp: false, isPressed: false, isSelected: true, isCentered: true)
    }

}
