// Kevin Li - 2:38 PM - 7/26/20

import SpriteKit
import UIKit

public class ColorNode: SKShapeNode {

    public var paletteColor: PaletteColor! {
        didSet {
            fillColor = paletteColor.uiColor
            label.text = paletteColor.name
            border.strokeColor = paletteColor.uiColor
        }
    }

    public var radius: CGFloat! {
        didSet {
            didUpdateRadius()

            label.fontSize = radius*0.7
            label.position.y = -(radius * 1.5)
        }
    }

    public lazy var label: SKLabelNode = {
        let node = SKLabelNode(fontNamed: "SanFranciscoDisplay-Regular")
        node.verticalAlignmentMode = .top
        node.zPosition = 5
        return node
    }()

    public var fontName: String? {
        get { label.fontName }
        set {
            label.fontName = newValue
        }
    }

    public var fontColor: UIColor? {
        get { label.fontColor }
        set {
            label.fontColor = newValue
        }
    }

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
            self.paletteColor = paletteColor
        }

        strokeColor = .clear
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

    func modifier(_ modifier: NodeModifier) -> ColorNode {
        modifier.body(content: self)
    }

}

