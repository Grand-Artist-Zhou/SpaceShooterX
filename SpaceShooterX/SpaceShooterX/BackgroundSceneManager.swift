//
//  BackgroundSceneManager.swift
//  SpaceShooterX
//
//  Created by Yuxuan Bu on 11/24/21.
//

import Foundation
import SceneKit
import SwiftUI

class BackgroundSceneManager: ObservableObject {
    public var scene: SCNScene!
    private var skybox: SCNNode!
    private var player: SCNNode!
    
    convenience init() {
        self.init("TitleScreenScene.scn", SCNVector3(0, 0, 0))
    }
    
    init(_ path: String, _ ld: SCNVector3) {
        scene = SCNScene(named: path)
        skybox = scene.rootNode.childNode(withName: "skybox", recursively: true)
        player = scene.rootNode.childNode(withName: "blend_root", recursively: true)
        let spin = CABasicAnimation(keyPath: "rotation")
        var axis = SCNVector3(1, 1, 0)
        let length = sqrt(axis.x * axis.x + axis.y * axis.y + axis.z * axis.z)
        axis.x /= length
        axis.y /= length
        axis.z /= length
        spin.fromValue = NSValue(scnVector4: SCNVector4(axis.x, axis.y, axis.z, 0))
        spin.toValue = NSValue(scnVector4: SCNVector4(axis.x, axis.y, axis.z, -Float(2 * Float.pi)))
        spin.duration = 60
        spin.repeatCount = .infinity
        skybox.addAnimation(spin, forKey: "r")
        
        let myLight1 = SCNNode()
        myLight1.light = SCNLight()
        myLight1.light!.type = .directional
        myLight1.light!.color = UIColor(white: 1.0, alpha: 0.3)
        myLight1.eulerAngles = ld
        scene.rootNode.addChildNode(myLight1)
    }
}

class ScoreBackgroundSceneManager: ObservableObject {
    public var scene: SCNScene!
    private var skybox: SCNNode!
    private var player: SCNNode!
    
    init(_ path: String, _ ld: SCNVector3) {
        scene = SCNScene(named: path)
        skybox = scene.rootNode.childNode(withName: "skybox", recursively: true)
        player = scene.rootNode.childNode(withName: "blend_root", recursively: true)
        let spin = CABasicAnimation(keyPath: "rotation")
        var axis = SCNVector3(1, 0, 0)
        let length = sqrt(axis.x * axis.x + axis.y * axis.y + axis.z * axis.z)
        axis.x /= length
        axis.y /= length
        axis.z /= length
        spin.fromValue = NSValue(scnVector4: SCNVector4(axis.x, axis.y, axis.z, 0))
        spin.toValue = NSValue(scnVector4: SCNVector4(axis.x, axis.y, axis.z, -Float(2 * Float.pi)))
        spin.duration = 60
        spin.repeatCount = .infinity
        skybox.addAnimation(spin, forKey: "r")
        
        let myLight1 = SCNNode()
        myLight1.light = SCNLight()
        myLight1.light!.type = .directional
        myLight1.light!.color = UIColor(white: 1.0, alpha: 0.3)
        myLight1.eulerAngles = ld
        scene.rootNode.addChildNode(myLight1)
    }
}

struct Background: View {
    var body: some View {
        Rectangle()
            .foregroundColor(.black)
            .frame(width: 1000, height: 1000)
    }
}
