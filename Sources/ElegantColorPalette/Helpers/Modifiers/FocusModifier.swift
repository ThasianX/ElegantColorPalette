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

private extension ColorNode {

    func snap(to location: CGPoint, multiplier: CGFloat, completion: @escaping () -> Void) {
        guard position != location else { return }

        let offset = CGPoint(x: location.x - position.x,
                             y: location.y - position.y)
        let snapVector = CGVector(dx: offset.x*multiplier,
                                  dy: offset.y*multiplier)
        physicsBody?.velocity = snapVector

        let distance = hypot(offset.x, offset.y)
        let moveDuration = 0.001*distance

        let moveAction = SKAction.move(to: location,
                                       duration: TimeInterval(moveDuration))

        run(moveAction, completion: completion)
    }

}
