// Kevin Li - 2:38 PM - 7/26/20

import SpriteKit
import UIKit

fileprivate let circularShiftRadians: Double = -20 * (.pi / 180)
// TODO: this depends on circleradius
fileprivate let innerRadius: CGFloat = circleRadius*3
fileprivate let rotationSpeed: CGFloat = 30

class ColorsContainerNode: SKNode {

    init(colors: [PaletteColor]) {
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

        var spawnPositions = validPositions(within: size)

        for child in children {
            let spawnIndex = Int.random(in: 0..<spawnPositions.count)
            let spawnPosition = spawnPositions[spawnIndex]
            spawnPositions.remove(at: spawnIndex)
            child.position = spawnPosition

            child.setScale(0)

            let waitDuration: TimeInterval = .random(in: 0...0.4)
            let waitAction = SKAction.wait(forDuration: waitDuration)

            let fadeInAction = SKAction.fadeIn(withDuration: 0.4)
            let scaleUpAction = SKAction.scale(to: 1.1, duration: 0.4)
            let scaleDownAction = SKAction.scale(to: 1, duration: 0.2)

            let rotationVector = circularVector(for: child)
            let magnifiedRotationVector = CGVector(dx: rotationVector.dx*6, dy: rotationVector.dy*6)
            let rotationAction = SKAction.applyForce(magnifiedRotationVector, duration: 0.4)

            let actionSequence = SKAction.sequence([waitAction, .group([fadeInAction, scaleUpAction, rotationAction]), scaleDownAction])

            child.run(actionSequence)
        }
    }

    private func validPositions(within size: CGSize) -> [CGPoint] {
        var validPositions = [CGPoint]()

        let numberOfRows = Int(size.height*2 / (circleLength*1.1))
        let numberOfCols = Int(size.width*2 / circleLength*1.1)

        let startingXPos = -size.width
        let startingYPos = -size.height

        for row in 0..<numberOfRows {
            for col in 0..<numberOfCols {
                let point = CGPoint(x: startingXPos + (circleLength*1.1)*CGFloat(row),
                                    y: startingYPos + (circleLength*1.1)*CGFloat(col))
                validPositions.append(point)
            }
        }

        return validPositions
    }

    func rotateNodes() {
        for child in children {
            child.physicsBody?.applyForce(circularVector(for: child))
        }
    }

    private func circularVector(for child: SKNode) -> CGVector {
        let positionVector = CGVector(dx: child.position.x,
                                      dy: child.position.y)

        // Vector formula for rotating a vector theta degrees
        let newX = Double(positionVector.dx)*cos(circularShiftRadians) - Double(positionVector.dy)*sin(circularShiftRadians)
        let newY = Double(positionVector.dx)*sin(circularShiftRadians) + Double(positionVector.dy)*cos(circularShiftRadians)

        let newPositionVector = CGVector(dx: newX, dy: newY)
        let radiusVector = newPositionVector.asUnitVector * innerRadius

        // Invert the position vector to have its tip pointing towards the origin(0,0).
        // This makes the add operation more intuitive.
        let rotationVector = CGVector(dx: -positionVector.dx + radiusVector.dx,
                                      dy: -positionVector.dy + radiusVector.dy)
        let unitRotationVector = rotationVector.asUnitVector

        let normalizedRotationVector = CGVector(dx: unitRotationVector.dx * rotationSpeed,
                                                dy: unitRotationVector.dy * rotationSpeed)

        let entropyRotationVector = CGVector(dx: normalizedRotationVector.dx + CGFloat.random(in: -10...10),
                                             dy: normalizedRotationVector.dy + CGFloat.random(in: -10...10))

        return entropyRotationVector
    }

}
