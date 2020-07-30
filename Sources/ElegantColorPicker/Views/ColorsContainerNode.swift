// Kevin Li - 2:38 PM - 7/26/20

import SpriteKit
import UIKit

fileprivate let circularShiftRadians: Double = -20 * (.pi / 180)

class ColorsContainerNode: SKNode {

    private var nodeRadius: CGFloat!

    private lazy var nodeLength: CGFloat = {
        nodeRadius*2
    }()
    private lazy var innerRadius: CGFloat = {
        nodeLength*1.5
    }()
    private lazy var rotationSpeed: CGFloat = {
        nodeRadius
    }()

    init(colors: [PaletteColor], style: NodeStyle) {
        super.init()
        addColorNodes(colors: colors, with: style)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addColorNodes(colors: [PaletteColor], with style: NodeStyle) {
        for paletteColor in colors {
            let colorNode = ColorNode(paletteColor: paletteColor)
            let modifiedNode = style.apply(configuration: .startUp(colorNode, isSelected: false))
            addChild(modifiedNode)

            // TODO: find ways to remove this cuz this is ugly
            if nodeRadius == nil {
                nodeRadius = modifiedNode.radius
            }
        }
    }

    // TODO: make this based off the actual node's size
    func randomizeColorNodesPositionsWithBubbleAnimation(within size: CGSize) {
        var spawnPositions = validPositions(within: size)

        for child in children {
            let spawnIndex = Int.random(in: 0..<spawnPositions.count)
            let spawnPosition = spawnPositions[spawnIndex]
            spawnPositions.remove(at: spawnIndex)
            child.position = spawnPosition

            let rotationVector = circularVector(for: child)
            let magnifiedRotationVector = CGVector(dx: rotationVector.dx*6, dy: rotationVector.dy*6)
            let rotationAction = SKAction.applyForce(magnifiedRotationVector, duration: 0.4)

            child.run(rotationAction)
        }
    }

    private func validPositions(within size: CGSize) -> [CGPoint] {
        var validPositions = [CGPoint]()

        let numberOfRows = Int(size.height*2 / (nodeLength*1.1))
        let numberOfCols = Int(size.width*2 / nodeLength*1.1)

        let startingXPos = -size.width
        let startingYPos = -size.height

        for row in 0..<numberOfRows {
            for col in 0..<numberOfCols {
                let point = CGPoint(x: startingXPos + (nodeLength*1.1)*CGFloat(row),
                                    y: startingYPos + (nodeLength*1.1)*CGFloat(col))
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

extension ColorsContainerNode {

    func node(with color: PaletteColor?) -> ColorNode? {
        for child in children {
            if let node = child as? ColorNode, node.paletteColor == color {
                return node
            }
        }
        return nil
    }

}
