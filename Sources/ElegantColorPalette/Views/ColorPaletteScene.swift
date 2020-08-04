// Kevin Li - 2:31 PM - 7/26/20

import Combine
import SpriteKit
import UIKit

class ColorPaletteScene: SKScene {

    /// Keeps track of the touch state of the scene
    private enum TouchState {
        /// No user interaction
        case inactive
        /// Touched down
        case touched
        /// Touched down + panned
        case dragged
    }

    /// Keeps track of the local state of the scene
    private class InteractionState {
        /**
         The node with the currently selected `PaletteColor`.

         Instantiated based on the client provided `selectedColor`. Afterwards, it reflects the currently focused node
        */
        var selectedNode: ColorNode?

        /**
         Whether the `selectedNode` is 'focused'.

         A node is focused only when a tap interaction occurs with it
        */
        var isFocused: Bool = false

        /**
         Whether the `selectedNode` is at the focus point.
        */
        var didReachFocusPoint: Bool = false

        /**
         The node that is currently being tapped or dragged.

         This can be the same as `selectedNode` if that node is being tapped or dragged.
         This is `nil` when no user interaction is occuring.
        */
        var activeNode: ColorNode?

        /**
         The touch state of the `activeNode`
        */
        var touchState: TouchState = .inactive
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

}

// MARK: - Scene Did Appear
extension ColorPaletteScene {

    override func didMove(to view: SKView) {
        configureScenePhysics()

        paletteManager.$colors
            .sink { [unowned self] colors in
                self.colorsChanged(colors)
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

    private func colorsChanged(_ colors: [PaletteColor]) {
        if let containerNode = containerNode, containerNode.parent != nil {
            containerNode.children
                .compactMap { $0 as? ColorNode }
                .forEach { node in
                    node.physicsBody?.isDynamic = false
                    let scaleDownAction = SKAction.scale(to: 0, duration: 0.3)
                    let fadeAwayAction = SKAction.fadeOut(withDuration: 0.3)
                    let removalAction = SKAction.removeFromParent()

                    let removalSequence = SKAction.sequence([.group([scaleDownAction, fadeAwayAction]), removalAction])

                    node.run(removalSequence)
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                containerNode.removeFromParent()
            }
        }

        state = .init()

        guard colors.count > 0 else { return }

        let newContainer = ColorsContainerNode(colors: colors, style: paletteManager.nodeStyle)
        addChild(newContainer)

        if let selectedNode = newContainer.node(with: paletteManager.selectedColor) {
            state.selectedNode = paletteManager.nodeStyle.updateNode(
                configuration: .firstShown(selectedNode, isSelected: true))
        }

        let smallerLength = min(size.width, size.height)
        let spawnSize = CGSize(width: (smallerLength/2)-40, height: (smallerLength/2)-40)
        newContainer.randomizeColorNodesPositionsWithBubbleAnimation(within: spawnSize)
        
        containerNode = newContainer
    }

    private func colorSchemeChanged() {
        guard containerNode != nil else { return }

        containerNode.children
            .compactMap { $0 as? ColorSchemeObserver }
            .forEach { $0.colorSchemeChanged() }
    }

}

// https://stackoverflow.com/questions/30362586/manually-move-node-over-a-period-of-time/30408800#30408800
// MARK: - Node Rotation
extension ColorPaletteScene {

    override func update(_ currentTime: TimeInterval) {
        guard containerNode != nil else { return }

        // Always going to rotate the nodes no matter the circumstance
        containerNode.rotateNodes(selectedNode: state.selectedNode, isFocused: state.isFocused)
        guard let selectedNode = state.selectedNode, state.isFocused else { return }

        guard state.touchState != .dragged else {
            selectedNode.physicsBody?.isDynamic = true
            return
        }

        // Defines the smoothing rate of the focus animation. This is subject to change
        // for circumstances where the user isn't doing anything and the external nodes
        // naturally collide into the focused node. For those circumstances, we want the
        // rebound velocity to be smalle.
        var rate = focusSettings.smoothingRate

        let distanceFromCenter = selectedNode.position.distance(from: focusSettings.location)
        // 10 is an arbitrary number that compensates for the frames at which is the scene is running at.
        if distanceFromCenter < 10 {
            // The body of the if only ever gets executed if previously, the selected node
            // wasn't focused. Prevents unnecessary calls to `updateNode`
            if !state.didReachFocusPoint {
                // very hacky. it's best to never mix physics with actions but it works so....
                selectedNode.physicsBody?.isDynamic = false
                selectedNode.run(SKAction.move(to: focusSettings.location, duration: 0.25))
                selectedNode.physicsBody!.velocity = CGVector(dx: 0, dy: 0)
                paletteManager.nodeStyle.updateNode(configuration: .selectedAndFocused(selectedNode))
            }
            state.didReachFocusPoint = true
        } else {
            selectedNode.physicsBody?.isDynamic = true
            // Like I mentioned earlier, the rebound velocity should be smaller for naturally colliding nodes
            // We now it's naturally colliding because the current node's already reached the focus point
            if state.didReachFocusPoint {
                rate /= 2
            }
            state.didReachFocusPoint = false
        }

        guard !state.didReachFocusPoint else { return }

        let disp = CGVector(dx: focusSettings.location.x - selectedNode.position.x,
                            dy: focusSettings.location.y - selectedNode.position.y)
        let angle = atan2(disp.dy, disp.dx)
        let vel = CGVector(dx: cos(angle)*focusSettings.speed.dx,
                           dy: sin(angle)*focusSettings.speed.dy)

        let currentVelocity = selectedNode.physicsBody!.velocity
        let relVel = CGVector(dx: vel.dx - currentVelocity.dx,
                              dy: vel.dy - currentVelocity.dy)
        selectedNode.physicsBody!.velocity = CGVector(dx: currentVelocity.dx + relVel.dx*rate,
                                                      dy: currentVelocity.dy + relVel.dy*rate)
    }

    private var focusSettings: FocusSettings {
        paletteManager.focusSettings
    }

}

// MARK: - Touches Began
extension ColorPaletteScene {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = touches.first?.location(in: self) else { return }
        guard let node = node(at: location) else { return }

        state.activeNode = paletteManager.nodeStyle.updateNode(
            configuration: .touchedDown(node,
                                        isSelected: isNodeSelected(node),
                                        isFocused: isNodeFocused(node)))
        state.touchState = .touched
    }

    private func node(at location: CGPoint) -> ColorNode? {
        for node in nodes(at: location) {
            if let colorNode = node as? ColorNode {
                return colorNode
            }
        }
        return nil
    }

}

// MARK: - Touches Moved
fileprivate let dragVelocityMultiplier: CGFloat = 10

extension ColorPaletteScene {

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let activeNode = state.activeNode else { return }
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let previous = touch.previousLocation(in: self)
        guard location.distance(from: previous) != 0 else { return }
        guard isTouchWithinFrame(location) else { return }

        let offset = CGPoint(x: location.x - activeNode.position.x,
                             y: location.y - activeNode.position.y)
        let dragVector = CGVector(dx: offset.x * dragVelocityMultiplier,
                                  dy: offset.y * dragVelocityMultiplier)

        activeNode.physicsBody?.velocity = dragVector
        activeNode.position = location

        state.touchState = .dragged
    }

    private func isTouchWithinFrame(_ location: CGPoint) -> Bool {
        (location.x >= -frame.size.width/2 && location.x <= frame.size.width/2) &&
            (location.y >= -frame.size.height/2 && location.y <= frame.size.height/2)
    }

}

// MARK: - Touches Ended
extension ColorPaletteScene {

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let activeNode = state.activeNode else { return }

        switch state.touchState {
        case .touched:
            handleTouch(for: activeNode)
        case .dragged:
            handleDrag(for: activeNode)
        default:
            ()
        }

        state.touchState = .inactive
        state.activeNode = nil
    }

    private func handleTouch(for node: ColorNode) {
        if isNodeSelected(node) {
            // Currently focused node is tapped.
            if state.isFocused {
                paletteManager.nodeStyle.updateNode(configuration: .selectedAndFocused(node))
            } else {
                // This case only happens when you start out with a `selectedColor`.
                // In that case, the node will initially show its selected state but won't be focused.
                state.isFocused = true
                focusSelectedNode()
            }
        } else {
            // Deselect previously selected node if any
            if let oldSelectedNode = state.selectedNode {
                // Prevents weird bugs that occur when you tap multiple nodes in succession
                oldSelectedNode.removeAllActions()
                oldSelectedNode.physicsBody?.isDynamic = true
                paletteManager.nodeStyle.updateNode(configuration: .unselected(oldSelectedNode))
            }

            // Store new selected node
            state.isFocused = true
            state.selectedNode = node
            focusSelectedNode()
        }
    }

    private func handleDrag(for node: ColorNode) {
        if isNodeFocused(node) {
            // If the node is already focused, make sure to refocus it
            focusSelectedNode()
        } else {
            paletteManager.nodeStyle.updateNode(
                configuration: .touchedUp(node,
                                          isSelected: isNodeSelected(node),
                                          isFocused: false))
        }
    }

    private func focusSelectedNode() {
        guard let selectedNode = state.selectedNode else { return }

        paletteManager.selectedColor = selectedNode.paletteColor
    }

}

// MARK: - Shared Node Helpers
private extension ColorPaletteScene {

    func isNodeSelected(_ node: ColorNode) -> Bool {
        node == state.selectedNode
    }

    func isNodeFocused(_ node: ColorNode) -> Bool {
        isNodeSelected(node) && state.isFocused
    }

}

// MARK: - Extensions
private extension CGPoint {

    func distance(from point: CGPoint) -> CGFloat {
        return hypot(point.x - x, point.y - y)
    }
    
}
