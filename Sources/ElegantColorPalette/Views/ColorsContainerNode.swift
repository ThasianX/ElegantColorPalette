// Kevin Li - 2:38 PM - 7/26/20

import SpriteKit
import UIKit

fileprivate let circularShiftRadians: Double = -20 * (.pi / 180)

class ColorsContainerNode: SKNode {

    init(colors: [PaletteColor], style: NodeStyle) {
        super.init()
        addColorNodes(colors: colors, with: style)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addColorNodes(colors: [PaletteColor], with style: NodeStyle) {
        for paletteColor in colors {
            let colorNode = style.updateNode(
                configuration: .firstShown(ColorNode(paletteColor: paletteColor),
                                        isSelected: false))
            addChild(colorNode)
        }
    }

    func randomizeColorNodesPositionsWithBubbleAnimation(within size: CGSize) {
        let largestRadius: CGFloat = allColorNodes
            .max(by: { $0.radius > $1.radius })!
            .radius

        var validSpawnPositions = generateSpawnPositions(within: size,
                                                         nodeLength: largestRadius*2)

        allColorNodes
            .forEach { child in
                spawnNodeAndBeginRotation(child, validSpawns: &validSpawnPositions)
            }
    }

    private func generateSpawnPositions(within size: CGSize, nodeLength: CGFloat) -> [CGPoint] {
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

    private func spawnNodeAndBeginRotation(_ node: ColorNode, validSpawns: inout [CGPoint]) {
        guard validSpawns.count > 0 else {
            fatalError("Error: Not enough valid spawn positions to spawn node. Try lowering your node radius or the number of colors you have.")
        }

        let spawnIndex = Int.random(in: 0..<validSpawns.count)
        let spawnPosition = validSpawns[spawnIndex]
        validSpawns.remove(at: spawnIndex)
        node.position = spawnPosition

        let rotationVector = circularVector(for: node)
        let magnifiedRotationVector = CGVector(dx: rotationVector.dx*6, dy: rotationVector.dy*6)
        let rotationAction = SKAction.applyForce(magnifiedRotationVector, duration: 0.4)

        node.run(rotationAction)
    }

    func rotateNodes(selectedNode: ColorNode?, isFocused: Bool) {
        allColorNodes
            .forEach { node in
                let isNodeFocused = node.paletteColor == selectedNode?.paletteColor && isFocused
                if !isNodeFocused {
                    applyCircularRotation(for: node)
                }
        }
    }

    private func applyCircularRotation(for child: ColorNode) {
        child.physicsBody?.applyForce(circularVector(for: child))
    }

    private func circularVector(for child: ColorNode) -> CGVector {
        let innerRadius = child.radius * 3
        let rotationSpeed: CGFloat = child.radius

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

        let entropyRotationVector = CGVector(dx: normalizedRotationVector.dx + CGFloat.random(in: -5...5),
                                             dy: normalizedRotationVector.dy + CGFloat.random(in: -5...5))

        return entropyRotationVector
    }

}

extension ColorsContainerNode {

    var allColorNodes: [ColorNode] {
        children
            .compactMap { $0 as? ColorNode }
    }

    func node(with color: PaletteColor?) -> ColorNode? {
        for child in children {
            if let node = child as? ColorNode, node.paletteColor == color {
                return node
            }
        }
        return nil
    }

}
