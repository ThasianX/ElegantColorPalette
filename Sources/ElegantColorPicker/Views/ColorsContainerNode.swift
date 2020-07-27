// Kevin Li - 2:38 PM - 7/26/20

import SpriteKit
import UIKit

fileprivate let circularShiftRadians: Double = -20 * (.pi / 180)
// TODO: this depends on circleradius
fileprivate let innerRadius: CGFloat = 70

class ColorsContainerNode: SKNode {

    let gravityMultiplier: CGFloat

    init(colors: [PaletteColor], gravityMultiplier: CGFloat) {
        self.gravityMultiplier = gravityMultiplier
        super.init()
        addColorNodes(colors: colors)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addColorNodes(colors: [PaletteColor]) {
        for paletteColor in colors {
            let colorNode = ColorNode(circleOfRadius: circleRadius, paletteColor: paletteColor)
            addChild(colorNode)
        }
    }

    func randomizeColorNodesPositionsWithBubbleAnimation(within size: CGSize) {
        guard size != .zero else { return }

        for child in children {
            // TODO: refine the positioning such that they aren't spawning on top of each other at times
            child.position = CGPoint(
                x: Int.random(in: -Int(size.width)..<Int(size.width)),
                y: Int.random(in: -Int(size.height)..<Int(size.height)))

            child.setScale(0)

            let waitDuration: TimeInterval = .random(in: 0...0.4)
            let waitAction = SKAction.wait(forDuration: waitDuration)

            let fadeInAction = SKAction.fadeIn(withDuration: 0.4)
            let scaleUpAction = SKAction.scale(to: 1.1, duration: 0.4)
            let scaleDownAction = SKAction.scale(to: 1, duration: 0.2)

            let rotationVector = circularVector(for: child)
            let magnifiedRotationVector = CGVector(dx: rotationVector.dx*3, dy: rotationVector.dy*3)
            let rotationAction = SKAction.applyForce(magnifiedRotationVector, duration: 0.4)

            let actionSequence = SKAction.sequence([waitAction, .group([fadeInAction, scaleUpAction]), scaleDownAction, rotationAction])

            child.run(actionSequence)
        }
    }

    func rotateNodes() {
        for child in children {
            child.physicsBody?.applyForce(circularVector(for: child))
        }
    }

    // TODO: make this more variable such that it's not just the same circular pattern
    private func circularVector(for child: SKNode) -> CGVector {
        let xPos = child.position.x
        let yPos = child.position.y

        let newX = Double(xPos)*cos(circularShiftRadians) - Double(yPos)*sin(circularShiftRadians)
        let newY = Double(xPos)*sin(circularShiftRadians) + Double(yPos)*cos(circularShiftRadians)

        let magnitude = hypot(newX, newY)

        let unitVector = CGVector(dx: CGFloat(newX / magnitude),
                                  dy: CGFloat(newY / magnitude))
        let radiusVector = CGVector(dx: unitVector.dx * innerRadius,
                                    dy: unitVector.dy * innerRadius)

        let invertedDistanceVector = CGVector(dx: position.x - xPos,
                                              dy: position.y - yPos)

        return CGVector(dx: (invertedDistanceVector.dx + radiusVector.dx) * gravityMultiplier,
                                      dy: (invertedDistanceVector.dy + radiusVector.dy) * gravityMultiplier)
    }

}
