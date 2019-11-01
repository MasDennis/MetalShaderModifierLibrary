//
//  ShaderModifierDataSource.swift
//  ShaderModifierLibrary
//
//  Created by Dennis Ippel on 30/01/2019.
//  Copyright © 2019 Rozengain. All rights reserved.
//

import UIKit
import SceneKit

enum TargetMeshType {
    case cube
    case quad
    case sphere
    case suzanne
}

struct ShaderModifierEntity {
    var name: String
    var shaderModifier: String
    var entryPoint: SCNShaderModifierEntryPoint
    var targetMeshType: TargetMeshType
    var backgroundImageName: String?
}

class ShaderModifierDataSource {
    public var shaderModifiers: [ShaderModifierEntity]
    
    init() {
        shaderModifiers = [ShaderModifierEntity]()
        populateArray()
    }
    
    private func populateArray() {
        shaderModifiers.append(
            ShaderModifierEntity(
                name: "Circle",
                shaderModifier: shaderModifier(named: "circle.fragment"),
                entryPoint: .fragment,
                targetMeshType: .quad))
        shaderModifiers.append(
            ShaderModifierEntity(
                name: "Multiple circles",
                shaderModifier: shaderModifier(named: "multi_circle.fragment"),
                entryPoint: .fragment,
                targetMeshType: .quad))
        shaderModifiers.append(
            ShaderModifierEntity(
                name: "Zoom",
                shaderModifier: shaderModifier(named: "zoom.geometry"),
                entryPoint: .geometry,
                targetMeshType: .quad,
                backgroundImageName: "uv_grid.jpg"))
//        shaderModifiers.append(
//            ShaderModifierEntity(
//                name: "Suzanne",
//                previewImage: image(named: "icon_circle"),
//                shaderModifier: shaderModifier(named: "circle.fragment"),
//                entryPoint: .fragment,
//                targetMeshType: .suzanne))
    }
    
    private func image(named imageName: String) -> UIImage {
        return UIImage(named: imageName, in: Bundle.main, compatibleWith: nil)!
    }
    
    private func shaderModifier(named shaderModifierName: String) -> String {
        return try! String(contentsOfFile: Bundle.main.path(forResource: shaderModifierName, ofType: "shader")!, encoding: String.Encoding.utf8)
    }
}
