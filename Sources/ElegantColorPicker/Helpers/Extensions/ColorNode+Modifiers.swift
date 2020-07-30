// Kevin Li - 6:59 PM - 7/28/20

import Foundation
import UIKit
import SpriteKit

public extension ColorNode {

    func focus(_ active: Bool, on location: CGPoint = .zero, multiplier: CGFloat = 5) -> ColorNode {
        modifier(FocusModifier(focus: active, location: location, multiplier: multiplier))
    }

    func font(name: String = "SanFranciscoDisplay-Regular", uiColor: UIColor = .white) -> ColorNode {
        modifier(FontModifier(name: name, uiColor: uiColor))
    }

    // TODO: figure out how custom highlighting would work
    func highlight(_ active: Bool, customColor: UIColor? = nil) -> ColorNode {
        modifier(HighlightModifier(highlight: active))
    }

    func radius(_ radius: CGFloat) -> ColorNode {
        modifier(RadiusModifier(radius: radius))
    }

    func scaleFade(_ active: Bool, scale: CGFloat, opacity: CGFloat, animationDuration: TimeInterval = 0.2) -> ColorNode {
        active ? modifier(ScaleFadeModifier(scale: scale, opacity: opacity, animationDuration: animationDuration)) : self
    }

    func startUp(_ active: Bool, waitDuration: ClosedRange<TimeInterval> = 0...0.4, scaleUpDuration: TimeInterval = 0.4, scaleDownDuration: TimeInterval = 0.2) -> ColorNode {
        active ? modifier(StartUpModifier(waitDuration: waitDuration, scaleUpDuration: scaleUpDuration, scaleDownDuration: scaleDownDuration)) : self
    }

}
