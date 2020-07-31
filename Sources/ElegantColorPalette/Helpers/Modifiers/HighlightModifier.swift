// Kevin Li - 8:27 PM - 7/29/20

import Foundation

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
