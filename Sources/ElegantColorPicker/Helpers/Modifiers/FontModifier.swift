// Kevin Li - 11:00 PM - 7/29/20

import Foundation
import SpriteKit

struct FontModifier: NodeModifier {

    let name: String
    let uiColor: UIColor

    func body(content: Content) -> ColorNode {
        if content.fontName != name {
            content.fontName = name
        }

        if content.fontColor != uiColor {
            content.fontColor = uiColor
        }

        return content
    }

}
