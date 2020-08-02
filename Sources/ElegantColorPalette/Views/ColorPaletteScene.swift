// Kevin Li - 2:31 PM - 7/26/20

import Combine
import SpriteKit
import UIKit

class ColorPaletteScene: SKScene {

//    override var isUserInteractionEnabled: Bool {
//        get { true }
//        set { }
//    }

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
//        isUserInteractionEnabled = true
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
        guard colors.count > 0 else { return }

        if let containerNode = containerNode, containerNode.parent != nil {
            containerNode.removeFromParent()
        }

        state = .init()

        containerNode = ColorsContainerNode(colors: colors, style: paletteManager.nodeStyle)
        addChild(containerNode)

        if let selectedNode = containerNode.node(with: paletteManager.selectedColor) {
            state.selectedNode = paletteManager.nodeStyle.updateNode(configuration: .firstShown(selectedNode, isSelected: true))
        }

        let smallerLength = min(size.width, size.height)
        let spawnSize = CGSize(width: (smallerLength/2)-40, height: (smallerLength/2)-40)
        containerNode.randomizeColorNodesPositionsWithBubbleAnimation(within: spawnSize)
    }

    private func colorSchemeChanged() {
        guard containerNode != nil else { return }

        containerNode.children
            .compactMap { $0 as? ColorSchemeObserver }
            .forEach { $0.colorSchemeChanged() }
    }

}

// MARK: - Node Rotation
extension ColorPaletteScene {

    override func update(_ currentTime: TimeInterval) {
        guard containerNode != nil else { return }

        containerNode.rotateNodes()
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
        guard let location = touches.first?.location(in: self) else { return }
        guard isTouchWithinFrame(location) else { return }

        let offset = CGPoint(x: location.x - activeNode.position.x,
                             y: location.y - activeNode.position.y)
        let dragVector = CGVector(dx: offset.x * dragVelocityMultiplier,
                                  dy: offset.y * dragVelocityMultiplier)

        activeNode.physicsBody?.isDynamic = true
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
        case .inactive:
            ()
        }

        state.activeNode = nil
        state.touchState = .inactive
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let activeNode = state.activeNode else { return }

        switch state.touchState {
        case .touched:
            handleTouch(for: activeNode)
        case .dragged:
            handleDrag(for: activeNode)
        case .inactive:
            ()
        }

        state.activeNode = nil
        state.touchState = .inactive
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

        paletteManager.nodeStyle.updateNode(configuration: .selectedAndFocused(selectedNode))
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
