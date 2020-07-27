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

    func randomizeColorNodesPositions(within size: CGSize) {
        guard size != .zero else { return }

        for child in children {
            child.position = CGPoint(
                x: Int.random(in: -Int(size.width)..<Int(size.width)),
                y: Int.random(in: -Int(size.height)..<Int(size.height)))
        }
    }

    // TODO: refine this logic and make the rotation more variable
    func updateGravity() {
        for child in children {
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

            let circularVector = CGVector(dx: (invertedDistanceVector.dx + radiusVector.dx) * gravityMultiplier,
                                          dy: (invertedDistanceVector.dy + radiusVector.dy) * gravityMultiplier)
            // TODO: make this more variable such that it's not just the same circular pattern
            // TODO: fix some nodes in the beginning that don't move
            child.physicsBody?.applyForce(circularVector)
        }
    }

}
