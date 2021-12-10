//
//  WaveManager.swift
//  SpaceShooterX
//
//  Created by Yuxuan Bu on 11/2/21.
//

import Foundation
import SceneKit

struct Wave {
    let obj: GameObject
    let time: Double
    let pos: SCNVector3
}

public class WaveManager: GameObject {
    private var waves = [Wave]()
    private var timer = 0.0
    
    init(_ waves: [Wave]) {
        super.init(SCNNode())
        self.waves = waves
    }
    
    override public func update() {
        timer += Model.ins.deltaTime!
        
        if (!waves.isEmpty) {
            if timer >= waves[0].time {
                let t = waves.remove(at: 0)
                t.obj.node.position = t.pos
                let _ = Model.ins.addGameObject(t.obj)
            }
        }
    }
}
