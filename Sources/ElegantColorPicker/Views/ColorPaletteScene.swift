// Kevin Li - 2:31 PM - 7/26/20

import SpriteKit
import UIKit

let circleCount: Int = 20
// TODO: Add support for custom circle radius and custom circle count
let circleRadius: CGFloat = 25

class InteractionState {

    var selectedNode: ColorNode?

    var activeNode: ColorNode?
    var isDragging: Bool = false

}

fileprivate let dragVelocityMultiplier: CGFloat = 10
fileprivate let snapVelocityMultiplier: CGFloat = 5

class ColorPaletteScene: SKScene {

    var containerNode: ColorsContainerNode!

    var state: InteractionState = .init()

    override func didMove(to view: SKView) {
        configureScenePhysics()

        containerNode = ColorsContainerNode(gravityRange: max(size.width, size.height),
                                            gravityMultiplier: 0.5)
        addChild(containerNode)

        addColorNodesToContainer()

        // TODO: add animation of bubbling up when first loaded
    }

    private func configureScenePhysics() {
        scene?.physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        scene?.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        backgroundColor = .clear
    }

    private func addColorNodesToContainer() {
        for paletteColor in PaletteColor.allColors {
            let colorNode = ColorNode(circleOfRadius: circleRadius, paletteColor: paletteColor)
            containerNode.addChild(colorNode)

            colorNode.position = CGPoint(
                x: Int.random(in: -(Int(size.width) / 4)..<(Int(size.width) / 4)),
                y: Int.random(in: -(Int(size.height) / 4)..<(Int(size.height) / 4)))
        }
    }

    override func update(_ currentTime: TimeInterval) {
        containerNode.updateGravity()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)

        guard let node = node(at: location) else { return }

        state.activeNode = node
        node.highlight()
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let previous = touch.previousLocation(in: self)
        guard location.distance(from: previous) != 0 else { return }
        guard let activeNode = state.activeNode else { return }

        let offset = CGPoint(x: location.x - activeNode.position.x,
                             y: location.y - activeNode.position.y)
        let dragVector = CGVector(dx: offset.x*dragVelocityMultiplier,
                                  dy: offset.y*dragVelocityMultiplier)

        activeNode.position = location

        activeNode.physicsBody?.isDynamic = true
        activeNode.physicsBody?.velocity = dragVector

        state.isDragging = true
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let activeNode = state.activeNode else { return }
        activeNode.unhighlight()

        if state.isDragging {
            if activeNode == state.selectedNode {
                snapSelectedNodeToCenter()
            }
        } else {
            state.selectedNode?.unselect()
            state.selectedNode = activeNode
            snapSelectedNodeToCenter()
        }

        state.activeNode = nil
        state.isDragging = false
    }

    private func snapSelectedNodeToCenter() {
        let offset = CGPoint(x: -state.selectedNode!.position.x,
                             y: -state.selectedNode!.position.y)
        let snapVector = CGVector(dx: offset.x*snapVelocityMultiplier,
                                  dy: offset.y*snapVelocityMultiplier)
        state.selectedNode?.physicsBody?.velocity = snapVector

        let moveAction = SKAction.move(to: .zero, duration: 0.15)
        state.selectedNode?.run(moveAction) { [unowned self] in
            self.state.selectedNode?.select()
        }
    }

}

extension ColorPaletteScene {

    func node(at point: CGPoint) -> ColorNode? {
        nodes(at: point).compactMap { $0 as? ColorNode }.filter { $0.path!.contains(convert(point, to: $0)) }.first
    }

}

extension CGPoint {

    func distance(from point: CGPoint) -> CGFloat {
        hypot(point.x - x, point.y - y)
    }

}
