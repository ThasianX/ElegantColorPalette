// Kevin Li - 6:59 PM - 7/28/20

import Foundation
import UIKit
import SpriteKit

// TODO: allow user to customize the highlight color
// TODO: custom font name, font color for the selected node
public extension ColorNode {

    // TODO: figure out how custom highlighting would work
    func highlight(_ active: Bool, customColor: UIColor? = nil) -> ColorNode {
        modifier(HighlightModifier(highlight: active))
    }

    func scaleFade(_ active: Bool, scale: CGFloat, opacity: CGFloat, animationDuration: TimeInterval = 0.2) -> ColorNode {
        active ? modifier(ScaleFadeModifier(scale: scale, opacity: opacity, animationDuration: animationDuration)) : self
    }

    func focus(_ active: Bool, on location: CGPoint = .zero, multiplier: CGFloat = 5) -> ColorNode {
        modifier(FocusModifier(focus: active, location: location, multiplier: multiplier))
    }

}
