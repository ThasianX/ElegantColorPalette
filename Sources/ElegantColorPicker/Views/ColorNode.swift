// Kevin Li - 2:38 PM - 7/26/20

import SpriteKit
import UIKit

fileprivate let nameTopPadding: CGFloat = 10

// TODO: maybe let user subclass this? or make a user friendly api
class ColorNode: SKShapeNode {

    var paletteColor: PaletteColor!

    private lazy var nameNode: SKLabelNode = {
        let node = SKLabelNode(text: paletteColor.name)
        node.fontName = "SanFranciscoDisplay-Regular"
        node.fontSize = 17
        node.fontColor = .white
        node.verticalAlignmentMode = .top
        node.position.y -= (radius + nameTopPadding)
        node.zPosition = 5
        return node
    }()

    private lazy var borderNode: SKShapeNode = {
        let borderNode = SKShapeNode(circleOfRadius: radius + 3)
        borderNode.fillColor = .clear
        borderNode.strokeColor = paletteColor.uiColor
        borderNode.lineWidth = 1
        return borderNode
    }()

    convenience init(circleOfRadius radius: CGFloat, paletteColor: PaletteColor) {
        self.init(circleOfRadius: radius)

        self.paletteColor = paletteColor

        fillColor = paletteColor.uiColor
        strokeColor = .clear

        physicsBody = SKPhysicsBody(circleOfRadius: radius)
        // TODO: density is dependent on radius
        physicsBody?.density = 80
        physicsBody?.allowsRotation = false
    }

}

fileprivate let dragScale: CGFloat = 0.9
fileprivate let normalScale: CGFloat = 1
fileprivate let fadedAlpha: CGFloat = 0.3
fileprivate let normalAlpha: CGFloat = 1
fileprivate let animationDuration: TimeInterval = 0.2

extension ColorNode {

    func onTouchDown() {
        let scaleAction = SKAction.scale(to: dragScale, duration: animationDuration)
        let opacityAction = SKAction.fadeAlpha(to: fadedAlpha, duration: animationDuration)

        run(.group([scaleAction, opacityAction]))
    }

    func onTouchUp() {
        let scaleAction = SKAction.scale(to: normalScale, duration: animationDuration)
        let opacityAction = SKAction.fadeAlpha(to: normalAlpha, duration: animationDuration)

        run(.group([scaleAction, opacityAction]))
    }

}

extension ColorNode {

    func highlight() {
        if borderNode.parent == nil {
            addChild(borderNode)
        }
    }

    func unhighlight() {
        if borderNode.parent != nil {
            borderNode.removeFromParent()
        }
    }

    func focus() {
        physicsBody?.isDynamic = false
        if nameNode.parent == nil {
            addChild(nameNode)
        }
    }

    func unfocus() {
        physicsBody?.isDynamic = true
        if nameNode.parent != nil {
            nameNode.removeFromParent()
        }
    }

}
