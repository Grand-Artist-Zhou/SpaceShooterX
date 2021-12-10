//
//  Bullet.swift
//  SpaceShooterX
//
//  Created by Yizhou Li on 11/1/21.
//

import Foundation
import SceneKit

class BossBullet2: EnemyBullet {
    var spd: Float = 30
    var timer = 5.0
    
    init() {
        super.init(SCNNode())
        
        node.physicsBody = SCNPhysicsBody.kinematic()
        node.physicsBody?.contactTestBitMask = 1
        tag = .EnemyBullet
        
        let sphere = SCNSphere(radius: 0.2)
        sphere.firstMaterial!.diffuse.contents = UIColor.yellow
        node.geometry = sphere
    }
    
    override public func update() {
        move()
    }
    
    public func move() {
        timer -= Model.ins.deltaTime!
        
        if (timer <= 0) {
            Model.ins.removeGameObject(self)
            return
        }
       
        node.position.z += spd * Model.ins.deltaTimeF!
    }
}

class BossBullet1: EnemyBullet {
    var spd: Float = 10
    var timer = 5.0
    var dir: SCNVector3
    
    init(dir: SCNVector3) {
        self.dir = dir
        super.init(SCNNode())
        self.dir = (dir - node.position).normalized()
        
        node.physicsBody = SCNPhysicsBody.kinematic()
        node.physicsBody?.contactTestBitMask = 1
        tag = .EnemyBullet
        
        let sphere = SCNSphere(radius: 0.2)
        sphere.firstMaterial!.diffuse.contents = UIColor.yellow
        node.geometry = sphere
    }
    
    override public func update() {
        move()
    }
    
    public func move() {
        timer -= Model.ins.deltaTime!
        
        if (timer <= 0) {
            Model.ins.removeGameObject(self)
            return
        }
       
        node.position += dir * spd * Model.ins.deltaTimeF!
    }
}

class MachineGunBullet: EnemyBullet {
    var timer = 5.0
    var spd: Float = 4.0
    var dir: SCNVector3
    var accl: Float = 10.0
    
    init(selfPos: SCNVector3) {
        dir = (Model.ins.player.node.position - selfPos).normalized()
        super.init(SCNNode())
        
        node.physicsBody = SCNPhysicsBody.kinematic()
        node.physicsBody?.contactTestBitMask = 1
        tag = .EnemyBullet
        
        let sphere = SCNSphere(radius: 0.2)
        sphere.firstMaterial!.diffuse.contents = UIColor.yellow
        node.geometry = sphere
    }
    
    override public func update() {
        move()
    }
    
    public func move() {
        timer -= Model.ins.deltaTime!
        
        if (timer <= 0) {
            Model.ins.removeGameObject(self)
            return
        }
        spd += accl * Model.ins.deltaTimeF!
        node.position += dir * spd * Model.ins.deltaTimeF!
    }
}
