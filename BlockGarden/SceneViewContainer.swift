import SwiftUI
import SceneKit

struct SceneViewContainer: View {
    let scene: SCNScene
    let interactionHandler: (SCNView, CGPoint) -> Void
    let interactionEnded: () -> Void

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                SceneView(
                    scene: scene,
                    pointOfView: scene.rootNode.childNode(withName: "mainCamera", recursively: false),
                    options: [],
                    preferredFramesPerSecond: 60,
                    antialiasingMode: .multisampling4X,
                    delegate: nil,
                    technique: nil
                )
                .background(Color(red: 0.74, green: 0.92, blue: 1.0))

                GestureOverlay(
                    size: geometry.size,
                    interactionHandler: interactionHandler,
                    interactionEnded: interactionEnded
                )
            }
        }
    }
}

private struct GestureOverlay: UIViewRepresentable {
    let size: CGSize
    let interactionHandler: (SCNView, CGPoint) -> Void
    let interactionEnded: () -> Void

    func makeUIView(context: Context) -> TouchForwardingView {
        let view = TouchForwardingView()
        view.backgroundColor = .clear
        view.interactionHandler = interactionHandler
        view.interactionEnded = interactionEnded
        return view
    }

    func updateUIView(_ uiView: TouchForwardingView, context: Context) {
        uiView.interactionHandler = interactionHandler
        uiView.interactionEnded = interactionEnded
    }
}

final class TouchForwardingView: UIView {
    var interactionHandler: ((SCNView, CGPoint) -> Void)?
    var interactionEnded: (() -> Void)?

    override func didMoveToWindow() {
        super.didMoveToWindow()
        backgroundColor = .clear
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        handle(touches)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        handle(touches)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        interactionEnded?()
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        interactionEnded?()
    }

    private func handle(_ touches: Set<UITouch>) {
        guard
            let touch = touches.first,
            let sceneView = superview?.subviews.compactMap({ $0 as? SCNView }).first
        else {
            return
        }

        let point = touch.location(in: sceneView)
        interactionHandler?(sceneView, point)
    }
}
