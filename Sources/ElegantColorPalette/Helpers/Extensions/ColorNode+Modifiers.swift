// Kevin Li - 6:59 PM - 7/28/20

import Foundation
import UIKit
import SpriteKit

public extension ColorNode {

    /// Focuses this node to the supplied location with collision detection.
    ///
    /// A focus action consists of snapping this node to a location and making the name label visible.
    ///
    /// - Parameter active: Whether or not to focus this node.
    /// - Parameter location: The location to focus this node to.
    /// - Parameter multiplier: The bounciness of other nodes that this node collides into as it focuses.
    ///     The larger this value, the more bouncy other nodes are when they collide with this node.
    /// - Returns: A node that is/isn't focused on the supplied location.
    func focus(_ active: Bool, on location: CGPoint = .zero, multiplier: CGFloat = 10) -> ColorNode {
        modifier(FocusModifier(focus: active, location: location, multiplier: multiplier))
    }

    /// Sets the default font for the name label of this node.
    ///
    /// - Parameter name: The font name to use in this node.
    /// - Parameter uiColor: The font color to use in this node.
    /// - Returns: A node with the default font set to the value you supply.
    func font(name: String = "SanFranciscoDisplay-Regular", uiColor: UIColor = .label) -> ColorNode {
        modifier(FontModifier(name: name, uiColor: uiColor))
    }

    /// Adds or remove the border to this node.
    ///
    /// By default, the border appears outside the bounds of this node and is 10% larger than the radius of this node.
    /// The border color is also based off of the color of this node.
    ///
    /// - Important: If you would like to customize the border, create a new `SKNode` that matches the
    ///     type of border you want. Then create a new modifier that adds/removes the border depending on this node's state.
    ///
    /// - Parameters:
    ///   - active: Whether or not the highlighted border is visible.
    /// - Returns: A node with/without a highlighted border
    func highlight(_ active: Bool) -> ColorNode {
        modifier(HighlightModifier(highlight: active))
    }

    /// Sets the default radius for this node.
    ///
    /// Setting the radius also changes the default border's radius.
    ///
    /// - Parameter radius: The radius of this node.
    /// - Returns: A node with the default radius set to the value you supply.
    func radius(_ radius: CGFloat) -> ColorNode {
        modifier(RadiusModifier(radius: radius))
    }

    /// Scales and fades this node.
    ///
    /// For the `DefaultNodeStyle`, this is responsible for the opacity and scale change whenever a user holds down on
    /// a node and lets go.
    ///
    /// - Parameter active: Whether or not to scale and fade this node.
    /// - Parameter scale: A value that controls the scale of this node.
    /// - Parameter opacity: A value between 0(fully transparent) and 1(fully opaque).
    /// - Parameter animationDuration: The duration of the scale and fade animation.
    /// - Returns: A node that is scaled and faded to the value you supply.
    func scaleFade(_ active: Bool, scale: CGFloat, opacity: CGFloat, animationDuration: TimeInterval = 0.2) -> ColorNode {
        active ? modifier(ScaleFadeModifier(scale: scale, opacity: opacity, animationDuration: animationDuration)) : self
    }

    /// Sets the default startup animation for this node.
    ///
    /// For the `DefaultNodeStyle`,  this is responsible for the variable bubbling animation.
    ///
    /// - Parameter active: Whether or not the startup animation should be run.
    /// - Parameter waitDurationRange: The duration range that represents the variability at which nodes appear on the screen.
    /// - Parameter scaleUpDuration: The duration it takes for this node to scale up.
    /// - Parameter scaleDownDuration: The duration it takes for this node to scale back to its normal size.
    /// - Returns: A node with the default startup animation set to the durations you supply.
    func startUp(_ active: Bool, waitDurationRange: ClosedRange<TimeInterval> = 0...0.4, scaleUpDuration: TimeInterval = 0.4, scaleDownDuration: TimeInterval = 0.2) -> ColorNode {
        active ? modifier(StartUpModifier(waitDurationRange: waitDurationRange, scaleUpDuration: scaleUpDuration, scaleDownDuration: scaleDownDuration)) : self
    }

}
