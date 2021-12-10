//
//  Player.swift
//  SpaceShooterX
//
//  Created by Yuxuan Bu on 11/18/21.
//

import Foundation
import SceneKit

class Trail: GameObject {
    init() {
        let trailScene = SCNScene(named: "Trail.scn")
        let trailNode = trailScene?.rootNode.childNode(withName: "Trail", recursively: true)!
        super.init(trailNode!)
    }
    
    override func update() {
        node.position = Model.ins.player.node.position
        node.position.y += 0.4
        node.position.z += 1.3
    }
}

class Player: GameObject {
    public static var pm: SCNNode?
    
    public var spd = CGPoint()
    
    public var firing = false
    private var fireTimer = 0.0
    private var fireDelta = 0.07
    
    public let maxHp = 5
    @Published public var hp = 5
    
    private var trialID = -1
    
    init() {
        super.init(Player.pm!)
        
        node.position.y -= 0.2
        node.scale = SCNVector3(0.0007, 0.0007, -0.0007)
        
        tag = .Player
        
        node.position = SCNVector3(0, 0, -4)
        node.physicsBody = SCNPhysicsBody.kinematic()
        node.physicsBody?.restitution = 0
        node.physicsBody?.contactTestBitMask = 1
        print(node.boundingBox)
    }
    
    override func start() {
        trialID = Model.ins.addGameObject(Trail())
    }
    
    override public func update() {
        move()
        fire()
        adjust()
    }
    
    private func move() {
        if hp == 0 {
            return
        }
        
        
        //print(spd)
        var x = node.position.x + Float(spd.x * Model.ins.deltaTime! * 0.1)
        var y = node.position.y - Float(spd.y * Model.ins.deltaTime! * 0.1)
        let z = node.position.z
        
        Model.ins.skybox.node.eulerAngles.y += Float(spd.x) * Model.ins.deltaTimeF! * 0.001
        Model.ins.skybox.node.eulerAngles.x += Float(spd.y) * Model.ins.deltaTimeF! * 0.001
        
        if x < -4.5 {
            x = -4.5
        } else if x > 4.5 {
            x = 4.5
        }
        
        if y > 2.5 {
            y = 2.5
        } else if y < -2.5 {
            y = -2.5
        }
        
        node.position = SCNVector3(x, y, z)
    }
    
    private func fire() {
        if hp == 0 {
            return
        }
        
        fireTimer += Model.ins.deltaTime!
        
        if (firing && fireTimer >= fireDelta) {
            let b = Bullet()
            b.node.position = node.position
            b.node.position.y += 0.4
            b.node.position.z -= 0.5
            let _ = Model.ins.addGameObject(b)
            fireTimer = 0
        }
    }
    
    private let rotSpd: Float = 2.0
    private let maxDegree: Float = 0.5
    
    private func adjust() {
        if hp == 0 {
            return
        }
        
        if spd.x == 0 {
            if abs(node.eulerAngles.z) < 0.1 {
                node.eulerAngles.z = 0
                return
            }
            else {
                node.eulerAngles.z += rotSpd * Model.ins.deltaTimeF! * (-abs(node.eulerAngles.z) / node.eulerAngles.z)
            }
        }
        else if spd.x < 0 {
            node.eulerAngles.z = min(maxDegree, node.eulerAngles.z + rotSpd * Model.ins.deltaTimeF!)
        }
        else if spd.x > 0 {
            node.eulerAngles.z = max(-maxDegree, node.eulerAngles.z - rotSpd * Model.ins.deltaTimeF!)
        }
    }
    
    public func hurt(_ v: Int) {
        if hp == 0 {
            return
        }
        
        hp -= v
        
        if hp <= 0 {
            hp = 0
            destroy()
        }
        
        DispatchQueue.main.async {
            Model.ins.php = self.hp
        }
    }
    
    private func destroy() {
        let expl = Explosion()
        expl.node.position = node.position
        let _ = Model.ins.addGameObject(expl)
        Model.ins.removeGameObject(Model.ins.objs[trialID]!)
        Model.ins.removeGameObject(self)
        Model.ins.gameover()
    }
}

class Bullet: GameObject {
    public static var bulletNode: SCNNode?
    
    private var timer = 4.0
    private var dz = -100.0
    
    init() {
        super.init(Bullet.bulletNode!.clone())
        
        self.tag = .PlayerBullet
        node.physicsBody = SCNPhysicsBody.kinematic()
        node.physicsBody?.restitution = 0
        node.physicsBody?.contactTestBitMask = 1
    }
    
    override public func update() {
        timer -= Model.ins.deltaTime!
        
        if (timer <= 0) {
            Model.ins.removeGameObject(self)
            return
        }
        
        node.position.z = node.position.z + Float(dz * Model.ins.deltaTime!)
    }
}
