//
//  GameViewController.swift
//  ShaderModifierLibrary
//
//  Created by Dennis Ippel on 30/01/2019.
//  Copyright © 2019 Rozengain. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController {
    @IBOutlet weak var sceneView: SCNView!
    
    private var dataSource: ShaderModifierDataSource?
    private var switcher: ShaderModifierSwitcher?
    private var perspectiveCameraNode: SCNNode?
    private var orthographicCameraNode: SCNNode?
    
    var selectedShaderModifier: ShaderModifierEntity?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = ShaderModifierDataSource()
        
        sceneView.allowsCameraControl = true
        sceneView.backgroundColor = UIColor.black
        sceneView.rendersContinuously = true
        
        let scene = SCNScene()
        sceneView.scene = scene

        let cameraLookAtNode = SCNNode()
        scene.rootNode.addChildNode(cameraLookAtNode)
        
        let perspectiveCameraNode = SCNNode()
        perspectiveCameraNode.camera = SCNCamera()
        perspectiveCameraNode.position = SCNVector3(-3, 3, 3)
        perspectiveCameraNode.constraints = [ SCNLookAtConstraint(target: cameraLookAtNode) ]
        scene.rootNode.addChildNode(perspectiveCameraNode)
        self.perspectiveCameraNode = perspectiveCameraNode
        
        let orthographicCameraNode = SCNNode()
        orthographicCameraNode.camera = SCNCamera()
        orthographicCameraNode.camera?.usesOrthographicProjection = true
        orthographicCameraNode.position = SCNVector3(0, 0, 1)
        scene.rootNode.addChildNode(orthographicCameraNode)
        self.orthographicCameraNode = orthographicCameraNode
        
        sceneView.pointOfView = perspectiveCameraNode
        
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = .omni
        lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
        scene.rootNode.addChildNode(lightNode)
        
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = .ambient
        ambientLightNode.light!.color = UIColor.darkGray
        scene.rootNode.addChildNode(ambientLightNode)
        
        switcher = ShaderModifierSwitcher(with: sceneView)
        
        if let firstShader = dataSource?.shaderModifiers.first {
            didSelect(shaderModifier: firstShader)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let shaderModifier = selectedShaderModifier {
            didSelect(shaderModifier: shaderModifier)
            selectedShaderModifier = nil
        }
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "shaderModifierTableSegue",
            let vc = segue.destination as? ShaderModifierTableViewController {
            vc.shaderDataSource = dataSource
            vc.shaderModifierSelectionDelegate = self
        }
    }
}

extension GameViewController: ShaderModifierSelectionDelegate {
    func didSelect(shaderModifier: ShaderModifierEntity) {
        switcher?.switchTo(shaderModifier: shaderModifier)
        
        switch shaderModifier.targetMeshType {
        case .quad:
            sceneView.pointOfView = orthographicCameraNode
            sceneView.allowsCameraControl = false
        default:
            sceneView.pointOfView = perspectiveCameraNode
            sceneView.allowsCameraControl = true
        }
    }
}
