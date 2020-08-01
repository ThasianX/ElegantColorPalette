// Kevin Li - 9:59 PM - 7/29/20

import Foundation
import SpriteKit

struct StartUpModifier: NodeModifier {

    let waitDurationRange: ClosedRange<TimeInterval>
    let scaleUpDuration: TimeInterval
    let scaleDownDuration: TimeInterval

    func body(content: Content) -> ColorNode {
        content.setScale(0)

        let waitDuration: TimeInterval = .random(in: waitDurationRange)
        let waitAction = SKAction.wait(forDuration: waitDuration)

        let fadeInAction = SKAction.fadeIn(withDuration: scaleUpDuration)
        let scaleUpAction = SKAction.scale(to: 1.1, duration: scaleUpDuration)
        let scaleDownAction = SKAction.scale(to: 1, duration: scaleDownDuration)

        let actionSequence = SKAction.sequence([waitAction, .group([fadeInAction, scaleUpAction]), scaleDownAction])

        content.run(actionSequence)

        return content
    }

}
