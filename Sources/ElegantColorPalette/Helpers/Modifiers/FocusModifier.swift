// Kevin Li - 8:27 PM - 7/29/20

import Foundation
import SpriteKit
import UIKit

struct LabelModifier: NodeModifier {

    let show: Bool

    func body(content: Content) -> ColorNode {
        if show {
            content.addNameLabel()
        } else {
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
