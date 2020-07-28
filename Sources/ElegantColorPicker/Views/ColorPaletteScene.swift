// Kevin Li - 2:31 PM - 7/26/20

import SpriteKit
import UIKit

// TODO: Add support for custom circle radius and custom circle count. circleradius should be up to user to provide
let circleRadius: CGFloat = 25
let circleLength = circleRadius*2

fileprivate let dragVelocityMultiplier: CGFloat = 10
fileprivate let snapVelocityMultiplier: CGFloat = 5

// TODO: add variables, delegates that can track which color is selected and customizability of the colornode like if they want to add extra animations
// TODO: allow user to pass in initial selected color and configure view off that
class ColorPaletteScene: SKScene {

    private class InteractionState {
        var selectedNode: ColorNode?

        var activeNode: ColorNode?
        var isDragging: Bool = false
    }

    let paletteColors: [PaletteColor]

    lazy private var containerNode: ColorsContainerNode = {
        ColorsContainerNode(colors: paletteColors)
    }()

    private var state: InteractionState = .init()

    init(colors: [PaletteColor]) {
        paletteColors = colors
        super.init(size: .zero)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMove(to view: SKView) {
        configureScenePhysics()

        addChild(containerNode)

        let spawnSize = CGSize(width: (size.width/2)-40, height: size.height/4)
        containerNode.randomizeColorNodesPositionsWithBubbleAnimation(within: spawnSize)
    }

    private func configureScenePhysics() {
        scene?.physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        scene?.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        backgroundColor = .clear
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
        node.highlight()
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

        // TODO: fix rough moveto animation at times
        let moveAction = SKAction.move(to: .zero, duration: 0.15)
        state.selectedNode?.run(moveAction) { [unowned self] in
            self.state.selectedNode?.select()
        }
    }

}
