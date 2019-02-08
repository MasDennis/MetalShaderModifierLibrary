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

        material.shaderModifiers = [
            SCNShaderModifierEntryPoint.geometry:
            "#pragma arguments\n" +
            "vec2 sincos(float t) { return vec2(sin(t), cos(t)); }\n" +
            "#pragma body\n" +
            "_geometry.position.xy = sincos(u_time) * 6.0;",
            SCNShaderModifierEntryPoint.fragment:
            "_output.color = vec4(0.0, 1.0, 0.0, 1.0);"
            ]
        
        material.diffuse.contents = UIColor.red
        node.geometry = SCNPlane(width: 1, height: 1)
        node.geometry?.firstMaterial = material
        sceneView?.scene?.rootNode.addChildNode(node)
        currentNode = node
    }
}
