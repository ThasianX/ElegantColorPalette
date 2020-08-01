// Kevin Li - 2:31 PM - 7/26/20

import Combine
import SpriteKit
import UIKit

fileprivate let dragVelocityMultiplier: CGFloat = 10
fileprivate let snapVelocityMultiplier: CGFloat = 5

class ColorPaletteScene: SKScene, ColorSchemeObserver {

    private class InteractionState {
        var selectedNode: ColorNode?
        var isCentered: Bool = false

        var activeNode: ColorNode?
        var isDragging: Bool = false
    }

    let paletteManager: ColorPaletteManager

    private var containerNode: ColorsContainerNode!

    private var state: InteractionState!

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

        paletteManager.$colors
            .sink { [unowned self] colors in
                self.updateColors(colors)
            }.store(in: &cancellables)

        paletteManager.$activeColorScheme
            .dropFirst()
            .removeDuplicates()
            .sink { [unowned self] _ in
                self.colorSchemeChanged()
            }.store(in: &cancellables)
    }

    private func configureScenePhysics() {
        scene?.physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        scene?.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        backgroundColor = .clear
    }

    private func updateColors(_ colors: [PaletteColor]) {
        guard colors.count > 0 else {
            fatalError("Error: At least 1 color must exist")
        }

        if let containerNode = containerNode, containerNode.parent != nil {
            containerNode.removeFromParent()
        }

        state = .init()

        containerNode = ColorsContainerNode(colors: colors, style: paletteManager.nodeStyle)
        addChild(containerNode)

        if let selectedNode = containerNode.node(with: paletteManager.selectedColor) {
            state.selectedNode = paletteManager.nodeStyle.apply(configuration: .startUp(selectedNode, isSelected: true))
        }

        let smallerLength = min(size.width, size.height)
        let spawnSize = CGSize(width: (smallerLength/2)-40, height: (smallerLength/2)-40)
        containerNode.randomizeColorNodesPositionsWithBubbleAnimation(within: spawnSize)
    }

    func colorSchemeChanged() {
        containerNode.children
            .compactMap { $0 as? ColorSchemeObserver }
            .forEach { $0.colorSchemeChanged() }
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


        let configuration: NodeStyleConfiguration = .touchedDown(node,
                                       isSelected: node == state.selectedNode,
                                       isCentered: node == state.selectedNode && state.isCentered)
        state.activeNode = paletteManager.nodeStyle.apply(configuration: configuration)
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
        guard let activeNode = state.activeNode else { return }

        let location = touch.location(in: self)
        guard location.x >= -frame.size.width/2 && location.x <= frame.size.width/2 else { return }
        guard location.y >= -frame.size.height/2 && location.y <= frame.size.height/2 else { return }

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

        // TODO: refine this logic
        if state.isDragging {
            if activeNode == state.selectedNode && state.isCentered {
                snapSelectedNodeToCenter()
            } else {
                let configuration: NodeStyleConfiguration = .touchedUp(activeNode,
                                               isSelected: activeNode == state.selectedNode,
                                               isCentered: activeNode == state.selectedNode && state.isCentered)
                paletteManager.nodeStyle.apply(configuration: configuration)
            }
        } else {
            if activeNode != state.selectedNode {
                state.isCentered = true
                if let oldSelectedNode = state.selectedNode {
                    oldSelectedNode.removeAllActions()
                    paletteManager.nodeStyle.apply(configuration: .unselected(oldSelectedNode))
                }
                state.selectedNode = activeNode
                snapSelectedNodeToCenter()
            } else if !state.isCentered {
                state.isCentered = true
                snapSelectedNodeToCenter()
            } else {
                let configuration: NodeStyleConfiguration = .touchedUp(activeNode,
                                               isSelected: activeNode == state.selectedNode,
                                               isCentered: activeNode == state.selectedNode && state.isCentered)
                paletteManager.nodeStyle.apply(configuration: configuration)
            }
        }

        state.activeNode = nil
        state.isDragging = false
    }

    private func snapSelectedNodeToCenter() {
        guard let selectedNode = state.selectedNode else { return }

        paletteManager.nodeStyle.apply(configuration: .selectedAndCentered(selectedNode))
        paletteManager.selectedColor = selectedNode.paletteColor
    }

}
