// Kevin Li - 9:59 PM - 7/29/20

import Foundation
import SpriteKit

struct StartUpModifier: NodeModifier {

    let waitDuration: ClosedRange<TimeInterval>
    let scaleUpDuration: TimeInterval
    let scaleDownDuration: TimeInterval

    func body(content: Content) -> ColorNode {
        content.setScale(0)

        let waitDuration: TimeInterval = .random(in: 0...0.4)
        let waitAction = SKAction.wait(forDuration: waitDuration)

        let fadeInAction = SKAction.fadeIn(withDuration: 0.4)
        let scaleUpAction = SKAction.scale(to: 1.1, duration: 0.4)
        let scaleDownAction = SKAction.scale(to: 1, duration: 0.2)

        let actionSequence = SKAction.sequence([waitAction, .group([fadeInAction, scaleUpAction]), scaleDownAction])

        content.run(actionSequence)

        return content
    }

}
