// Kevin Li - 11:09 PM - 7/29/20

import Foundation
import SpriteKit

struct RadiusModifier: NodeModifier {

    let radius: CGFloat

    func body(content: Content) -> ColorNode {
        if content.radius != radius {
            content.radius = radius
        }

        return content
    }

}
