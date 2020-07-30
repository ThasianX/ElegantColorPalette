// Kevin Li - 8:29 PM - 7/29/20

import Foundation
import SpriteKit

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
