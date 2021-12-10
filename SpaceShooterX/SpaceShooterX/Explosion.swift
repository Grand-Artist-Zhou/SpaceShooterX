//
//  Explosion.swift
//  SpaceShooterX
//
//  Created by Yuxuan Bu on 11/18/21.
//

import Foundation
import SceneKit

class Explosion: GameObject {
    public static var explNode: SCNNode!
    
    init() {
        super.init(Explosion.explNode!.clone())
    }
    
    private var timer = 0.0
    
    public override func update() {
        timer += Model.ins.deltaTime!
        
        if timer >= 1 {
            Model.ins.removeGameObject(self)
        }
    }
}


import Foundation
import SceneKit

class Blink: GameObject {
    public static var nod: SCNNode!
    
    init() {
        super.init(Blink.nod.clone())
    }
    
    private var timer = 0.0
    
    public override func update() {
        timer += Model.ins.deltaTime!
        
        if timer >= 0.1 {
            Model.ins.removeGameObject(self)
        }
    }
}

class Smoke: GameObject{
    public static var nod: SCNNode!
    
    init() {
        super.init(Smoke.nod.clone())
    }
    
    private var timer = 0.0

    public override func update() {
        timer += Model.ins.deltaTime!

        if timer >= 3 {
            Model.ins.removeGameObject(self)
        }
    }
}

class BurstSmoke: GameObject{
    public static var nod: SCNNode!
    
    init() {
        
        super.init(BurstSmoke.nod.clone())
    }
    
    private var timer = 0.0

    public override func update() {
        timer += Model.ins.deltaTime!

        if timer >= 0.5 {
            Model.ins.removeGameObject(self)
        }
    }
}
class ThermalLock: GameObject {
    public static var nod: SCNNode!
    
    init() {
        super.init(ThermalLock.nod.clone())
    }
    
    private var timer = 0.0
    
//    public override func update() {
//        timer += Model.ins.deltaTime!
//
//        if timer >= 0.1 {
//            Model.ins.removeGameObject(self)
//        }
//    }
}
