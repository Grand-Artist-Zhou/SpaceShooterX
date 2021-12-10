//
//  Enemy.swift
//  SpaceShooterX
//
//  Created by Yuxuan Bu on 11/2/21.
//

import Foundation
import SceneKit

// TODO: physics
public class Enemy: GameObject {
    public let maxHp: Int
    public var hp: Int
    public var score = 500
    
    init(node: SCNNode, maxHp: Int) {
        self.maxHp = maxHp
        self.hp = maxHp
        
        node.physicsBody = SCNPhysicsBody.kinematic()
        node.physicsBody?.restitution = 0
        node.physicsBody?.contactTestBitMask = 1
        
        super.init(node)
        self.tag = .Enemy
    }
    
    public func hurt() {
        hp -= 1
        if (hp <= 0) {
            destroy()
        }
    }
    
    public func destroy() {
        onDestroy()
        
        DispatchQueue.main.async {
            Model.ins.score += self.score
        }
        
        Model.ins.removeGameObject(self)
        let expl = Explosion()
        expl.node.position = node.position
        let _ = Model.ins.addGameObject(expl)
    }
    
    public func onDestroy() {}
    public func onCollide(_ collision: GameObject) {}
}

// Example
public class TestEnemy: Enemy {
    
    private var spd = SCNVector3(-2, 0, 0)
    private var timer = 0.5
    
    init() {
        let box = SCNBox(width: 1, height: 1, length: 1, chamferRadius: 0.1)
        box.firstMaterial!.diffuse.contents = UIColor.yellow
        let node = SCNNode(geometry: box)
        super.init(node: node, maxHp: 1)
    }
    
    public override func update() {
        node.position.x += spd.x * Model.ins.deltaTimeF!
        
        timer -= Model.ins.deltaTime!
        
        if timer <= 0 {
            timer = 0.5
            let b = TestEnemyBullet()
            b.node.position = node.position
            //Model.ins.addGameObject(b)
        }
        
        if node.position.x <= -8 {
            Model.ins.removeGameObject(self)
            print("Removed!")
        }
    }
}

public class EnemyBullet: GameObject {
    override init(_ node: SCNNode) {
        super.init(node)
        node.physicsBody = SCNPhysicsBody.kinematic()
        node.physicsBody?.contactTestBitMask = 1
        tag = .EnemyBullet
    }
}

public class TestEnemyBullet: EnemyBullet {
    public var spd = SCNVector3(0, 0, 3)
    
    init() {
        let box = SCNSphere(radius: 0.2)
        box.firstMaterial!.diffuse.contents = UIColor.yellow
        let node = SCNNode(geometry: box)
        super.init(node)
    }
    
    public override func update() {
        node.position.z += spd.z * Model.ins.deltaTimeF!
        
        if node.position.z > 10 {
            Model.ins.removeGameObject(self)
            print("Removed!")
        }
    }
}
