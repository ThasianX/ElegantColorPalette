// Kevin Li - 6:59 PM - 7/28/20

import Foundation
import UIKit
import SpriteKit

// TODO: allow user to customize the highlight color
// TODO: custom font name, font color for the selected node
public struct DefaultNodeStyle: NodeStyle {

    public func apply(configuration: Configuration) -> ColorNode {
        configuration.node
            .highlight(configuration.isSelected)
            .scaleAndFade(scale: configuration.isPressed ? 0.9 : 1,
                          opacity: configuration.isPressed ? 0.3 : 1)
            .focus(configuration.isCentered)
    }

}

public protocol NodeStyle {

    typealias Configuration = NodeStyleConfiguration

    @discardableResult
    func apply(configuration: Configuration) -> ColorNode

}

public struct NodeStyleConfiguration {

    public let node: ColorNode
    public let isPressed: Bool
    public let isSelected: Bool
    public let isCentered: Bool

}

public protocol NodeModifier {

    func body(content: Content) -> ColorNode

    /// The color node passed to `body()`.
    typealias Content = ColorNode

}

extension ColorNode {

    // TODO: figure out how custom highlighting would work
    func highlight(_ active: Bool, customColor: UIColor? = nil) -> ColorNode {
        modifier(HighlightModifier(highlight: active))
    }

    func scaleAndFade(scale: CGFloat, opacity: CGFloat, animationDuration: TimeInterval = 0.2) -> ColorNode {
        modifier(ScaleFadeModifier(scale: scale, opacity: opacity, animationDuration: animationDuration))
    }

    func focus(_ active: Bool, on location: CGPoint = .zero, multiplier: CGFloat = 5) -> ColorNode {
        modifier(FocusModifier(focus: active, location: location, multiplier: multiplier))
    }

}

struct ScaleFadeModifier: NodeModifier {

    let scale: CGFloat
    let opacity: CGFloat
    let animationDuration: TimeInterval

    func body(content: Content) -> ColorNode {
        let scaleAction = SKAction.scale(to: scale, duration: animationDuration)
        let opacityAction = SKAction.fadeAlpha(to: opacity, duration: animationDuration)

        content.run(.group([scaleAction, opacityAction]))

        return content
    }

}

struct HighlightModifier: NodeModifier {

    let highlight: Bool

    func body(content: Content) -> ColorNode {
        if highlight {
            content.addBorder()
        } else {
            content.removeBorder()
        }

        return content
    }

}

private extension ColorNode {

    func addBorder() {
        if border.parent == nil {
            addChild(border)
        }
    }

    func removeBorder() {
        if border.parent != nil {
            border.removeFromParent()
        }
    }

}

struct FocusModifier: NodeModifier {

    let focus: Bool
    let location: CGPoint
    let multiplier: CGFloat

    // TODO: fix bug where tapping another node after tapping one before causes overlap
    func body(content: Content) -> ColorNode {
        if focus {
            content.snap(to: location, multiplier: multiplier) {
                content.physicsBody?.isDynamic = false
                content.addNameLabel()
            }
        } else {
            content.physicsBody?.isDynamic = true
            content.removeNameLabel()
        }

        return content
    }

}

private extension ColorNode {

    func addNameLabel() {
        if label.parent == nil {
            addChild(label)
        }
    }

    func removeNameLabel() {
        if label.parent != nil {
            label.removeFromParent()
        }
    }

}

extension ColorNode {

    func snap(to location: CGPoint, multiplier: CGFloat, completion: @escaping () -> Void) {
        guard position != location else { return }

        let offset = CGPoint(x: -position.x,
                             y: -position.y)
        let snapVector = CGVector(dx: offset.x*multiplier,
                                  dy: offset.y*multiplier)
        physicsBody?.velocity = snapVector

        let delta = (offset.distance(from: location) / (radius*3)).clamped(to: 0...1)
        let duration = 0.15 - 0.15*(1 - delta)
        let moveAction = SKAction.move(to: location,
                                       duration: TimeInterval(duration))
        moveAction.timingMode = .easeInEaseOut

        run(moveAction, completion: completion)
    }

}
