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
    @IBOutlet weak var shaderCollectionView: ShaderModifierCollectionView!
    
    private var dataSource: ShaderModifierDataSource?
    private var switcher: ShaderModifierSwitcher?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = ShaderModifierDataSource()
        
        sceneView.allowsCameraControl = true
        sceneView.backgroundColor = UIColor.black
        
        let scene = SCNScene()
        sceneView.scene = scene

        let cameraLookAtNode = SCNNode()
        scene.rootNode.addChildNode(cameraLookAtNode)
        
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(-3, 3, 3)
        cameraNode.constraints = [ SCNLookAtConstraint(target: cameraLookAtNode) ]
        scene.rootNode.addChildNode(cameraNode)
        
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        shaderCollectionView.shaderDataSource = dataSource
        shaderCollectionView.selectionDelegate = self
        
        if let shaderModifier = dataSource?.shaderModifiers.first {
            didSelect(shaderModifier: shaderModifier)
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
}

extension GameViewController: ShaderModifierSelectionDelegate {
    func didSelect(shaderModifier: ShaderModifierEntity) {
        switcher?.switchTo(shaderModifier: shaderModifier)
    }
}
