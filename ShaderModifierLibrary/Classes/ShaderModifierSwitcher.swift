//
//  ShaderModifierSwitcher.swift
//  ShaderModifierLibrary
//
//  Created by Dennis Ippel on 08/02/2019.
//  Copyright © 2019 Rozengain. All rights reserved.
//

import Foundation
import SceneKit

class ShaderModifierSwitcher {
    private weak var sceneView: SCNView?
    private var currentShaderModifier: ShaderModifierEntity?
    private var currentNode: SCNNode?
    
    init(with sceneView: SCNView) {
        self.sceneView = sceneView
    }
    
    func switchTo(shaderModifier: ShaderModifierEntity) {
        createScene(for: shaderModifier)
        self.currentShaderModifier = shaderModifier
    }
    
    private func createScene(for shaderModifier: ShaderModifierEntity) {
        switch shaderModifier.targetMeshType {
        case .cube:
            load(sceneNamed: "Cube Scene")
        case .quad:
            createQuadScene()
        case .sphere:
            load(sceneNamed: "Sphere Scene")
        case .suzanne:
            load(sceneNamed: "Suzanne Scene")
        }
    }
        
    private func load(sceneNamed name: String) {
        guard
            let sceneView = sceneView,
            let path = Bundle.main.path(forResource: name, ofType: "scn", inDirectory: "art.scnassets"),
            let node = SCNReferenceNode(url: URL(fileURLWithPath: path))
            else { return }
        
        node.load()
        
        if let currentNode = currentNode {
            currentNode.removeFromParentNode()
        }
        sceneView.scene?.rootNode.addChildNode(node)
        currentNode = node
    }
    
    private func createQuadScene() {
        if let currentNode = currentNode {
            currentNode.removeFromParentNode()
        }
        
        let node = SCNNode()
        let material = SCNMaterial()

        material.diffuse.contents = UIImage(named: "uv_grid.jpg", in: Bundle.main, compatibleWith: nil)
        
        if let shaderModifier = currentShaderModifier {
            material.shaderModifiers = [ shaderModifier.entryPoint: shaderModifier.shaderModifier ]
        }
        
        node.geometry = SCNPlane(width: 1, height: 1)
        node.geometry?.firstMaterial = material
        sceneView?.scene?.rootNode.addChildNode(node)
        currentNode = node
        
        guard let orthoScale = sceneView?.pointOfView?.camera?.orthographicScale,
            let viewSize = sceneView?.frame.size
            else {
                return
        }
        
        var scale = SCNVector3()
        scale.x = Float(orthoScale) * 2.0 * Float(viewSize.width / viewSize.height)
        scale.y = Float(orthoScale) * 2.0
        scale.z = 1
        
        node.scale = scale
    }
}
