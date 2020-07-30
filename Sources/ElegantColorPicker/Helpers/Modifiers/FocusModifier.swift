// Kevin Li - 8:27 PM - 7/29/20

import Foundation
import SpriteKit
import UIKit

struct FocusModifier: NodeModifier {

    let focus: Bool
    let location: CGPoint
    let multiplier: CGFloat

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
