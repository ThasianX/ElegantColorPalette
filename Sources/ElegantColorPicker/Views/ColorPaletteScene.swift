// Kevin Li - 2:31 PM - 7/26/20

import Combine
import SpriteKit
import UIKit

fileprivate let dragVelocityMultiplier: CGFloat = 10
fileprivate let snapVelocityMultiplier: CGFloat = 5

class ColorPaletteScene: SKScene {

    private class InteractionState {
        var selectedNode: ColorNode?
        var shouldSnap = false

        var activeNode: ColorNode?
        var isDragging: Bool = false
    }

    let paletteManager: ColorPaletteManager
    let paletteConfiguration: ColorPaletteConfiguration

    private var containerNode: ColorsContainerNode!

    private var state: InteractionState = .init()

    private var cancellables = Set<AnyCancellable>()

    init(paletteManager: ColorPaletteManager, paletteConfiguration: ColorPaletteConfiguration) {
        self.paletteManager = paletteManager
        self.paletteConfiguration = paletteConfiguration
        super.init(size: .zero)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMove(to view: SKView) {
        configureScenePhysics()

        Publishers.CombineLatest(paletteManager.$colors, paletteConfiguration.$nodeRadius)
            .eraseToAnyPublisher()
            .sink { colors, radius in
                self.updateColors(colors, withRadius: radius)
            }.store(in: &cancellables)
    }

    private func configureScenePhysics() {
        scene?.physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        scene?.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        backgroundColor = .clear
    }

    private func updateColors(_ colors: [PaletteColor], withRadius radius: CGFloat) {
        if let containerNode = containerNode, containerNode.parent != nil {
            containerNode.removeFromParent()
        }

        state = .init()

        containerNode = ColorsContainerNode(colors: colors, radius: radius)
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

        let delta = (offset.distance(from: .zero) / (paletteConfiguration.nodeRadius*3)).clamped(to: 0...1)
        let duration = 0.15 - 0.15*(1 - delta)
        let moveAction = SKAction.move(to: .zero,
                                       duration: TimeInterval(duration))
        moveAction.timingMode = .easeInEaseOut

        state.selectedNode?.run(moveAction) { [unowned self] in
            self.state.selectedNode?.highlight()
            self.state.selectedNode?.focus()
            self.paletteManager.setSelectedColor(self.state.selectedNode!.paletteColor)
        }
    }

}
