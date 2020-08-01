// Kevin Li - 2:38 PM - 7/26/20

import SpriteKit
import UIKit

@objcMembers public class ColorNode: SKShapeNode {

    /**
     The label that displays the name of the selected color.
     */
    public lazy var label: SKLabelNode = {
        let node = SKLabelNode(fontNamed: "SanFranciscoDisplay-Regular")
        node.verticalAlignmentMode = .top
        node.zPosition = 5
        return node
    }()

    /**
     The highlighted border that appears when a node is selected.
     */
    public lazy var border: SKShapeNode = {
        let node = SKShapeNode()
        node.fillColor = .clear
        node.lineWidth = 1
        return node
    }()

    public convenience init(paletteColor: PaletteColor) {
        self.init()

        // Allows didSet to get called
        defer {
            radius = 25
            fontColor = .label
            self.paletteColor = paletteColor
        }

        strokeColor = .clear
    }

    /**
     The `PaletteColor` associated with this node.

     Responsible for determining the node's fill color, label text, and border stroke color
     */
    public var paletteColor: PaletteColor! {
        didSet {
            fillColor = paletteColor.uiColor
            label.text = paletteColor.name
            border.strokeColor = paletteColor.uiColor
        }
    }

    /**
     The font color of the label of this node.

     If you want different font colors for light and dark mode, make sure your `fontColor` is dynamic as well.
     */
    public var fontColor: UIColor! {
        didSet {
            label.fontColor = fontColor
        }
    }

    /**
     The radius of the node.

     Responsible for the label's font size and position beneath the node as well as the border radius.
     */
    public var radius: CGFloat! {
        didSet {
            didUpdateRadius()

            label.fontSize = radius*0.7
            label.position.y = -(radius * 1.5)
        }
    }

    private func didUpdateRadius() {
        updatePath()
        regeneratePhysicsBody()
    }

    private func updatePath() {
        guard let path = SKShapeNode(circleOfRadius: radius).path else { return }
        self.path = path

        guard let borderPath = SKShapeNode(circleOfRadius: radius*1.1).path else { return }
        border.path = borderPath
    }

    private func regeneratePhysicsBody() {
        physicsBody = SKPhysicsBody(circleOfRadius: radius)
        physicsBody?.density = radius * 3
        physicsBody?.allowsRotation = false
    }

}

public extension ColorNode {

    /**
     Applies a modifier to the `ColorNode`.
     */
    func modifier(_ modifier: NodeModifier) -> ColorNode {
        modifier.body(content: self)
    }

}

extension ColorNode: ColorSchemeObserver {

    func colorSchemeChanged() {
        self.paletteColor = { self.paletteColor }()
        self.fontColor = { self.fontColor }()
    }

}
