// Kevin Li - 2:31 PM - 7/26/20

import Combine
import SpriteKit
import UIKit

// TODO: Add support for custom circle radius and custom circle count. circleradius should be up to user to provide
let circleRadius: CGFloat = 25
let circleLength = circleRadius*2

fileprivate let dragVelocityMultiplier: CGFloat = 10
fileprivate let snapVelocityMultiplier: CGFloat = 5

// TODO: add variables, delegates that can track which color is selected and customizability of the colornode like if they want to add extra animations
class ColorPaletteScene: SKScene {

    private class InteractionState {
        var selectedNode: ColorNode?
        var shouldSnap = false

        var activeNode: ColorNode?
        var isDragging: Bool = false
    }

    let paletteManager: ColorPaletteManager

    private var containerNode: ColorsContainerNode!

    private var state: InteractionState = .init()

    private var cancellables = Set<AnyCancellable>()

    init(paletteManager: ColorPaletteManager) {
        self.paletteManager = paletteManager
        super.init(size: .zero)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMove(to view: SKView) {
        configureScenePhysics()

        paletteManager.$colors.sink { newColors in
            self.updateColors(newColors)
        }.store(in: &cancellables)
    }

    private func configureScenePhysics() {
        scene?.physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        scene?.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        backgroundColor = .clear
    }

    private func updateColors(_ colors: [PaletteColor]) {
        if let containerNode = containerNode, containerNode.parent != nil {
            containerNode.removeFromParent()
        }

        state = .init()

        containerNode = ColorsContainerNode(colors: colors)
        addChild(containerNode)

        if let selectedNode = containerNode.node(with: paletteManager.selectedColor) {
            selectedNode.highlight()
            state.selectedNode = selectedNode
        }

        let spawnSize = CGSize(width: (size.width/2)-40, height: size.height/4)
        containerNode.randomizeColorNodesPositionsWithBubbleAnimation(within: spawnSize)
    }

}

extension ColorPaletteScene {

    override func update(_ currentTime: TimeInterval) {
        containerNode.rotateNodes()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)

        guard let node = node(at: location) else { return }

        state.activeNode = node
        node.onTouchDown()
    }

    private func node(at location: CGPoint) -> ColorNode? {
        for node in nodes(at: location) {
            if let colorNode = node as? ColorNode {
                return colorNode
            }
        }
        return nil
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
        activeNode.onTouchUp()

        if state.isDragging {
            if activeNode == state.selectedNode && state.shouldSnap {
                snapSelectedNodeToCenter()
            }
        } else {
            if activeNode != state.selectedNode {
                state.shouldSnap = true
                state.selectedNode?.unfocus()
                state.selectedNode?.unhighlight()
                state.selectedNode = activeNode
                snapSelectedNodeToCenter()
            } else if !state.shouldSnap {
                state.shouldSnap = true
                state.selectedNode?.focus()
                snapSelectedNodeToCenter()
            }
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
        moveAction.timingMode = .easeInEaseOut

        state.selectedNode?.run(moveAction) { [unowned self] in
            self.state.selectedNode?.highlight()
            self.state.selectedNode?.focus()
            self.paletteManager.setSelectedColor(self.state.selectedNode!.paletteColor)
        }
    }

}

extension ColorPaletteScene {



}
