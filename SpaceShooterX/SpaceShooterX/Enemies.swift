//
//  Model.swift
//  SpaceShooterX
//
//  Created by Yizhou Li on 10/26/21.
//

import Foundation
import SceneKit

class Meteoroid: Enemy {
    public static var nod: SCNNode!
    var playerPos = Model.ins.player.node.position
    var spd: Float = 20
    
    init() {
        super.init(node: Meteoroid.nod.clone(), maxHp: 2)
        node.scale = SCNVector3(0.05, 0.05, 0.05)
    }
    
    override public func update() {
        move()
        elim()
    }
    
    private func move() {
        node.position.z += spd * Model.ins.deltaTimeF!
    }
    
    private func elim() {
        if node.position.z >= 4 {
            Model.ins.removeGameObject(self)
        }
    }
}

class Enemy216: Enemy {
    public static var nod: SCNNode!
    
    private var fireTimer = 0.0
    private var fireDelta = 0.5
    
    var targetPos = Model.ins.player.node.position
    var originPos = SCNVector3()

    var spd: Float = 10
    var isMoving = true
    
    var state = 0
    var decl: Float = -1.0
    var iSpd: Float = 4.0
    var ttimer = 0.0
    
    init() {
        super.init(node: Enemy216.nod.clone(), maxHp: 2)
        node.scale = SCNVector3(2.5, 2.5, 2.5)
    }
    
    override func start() {
        originPos = node.position
    }

    override public func update() {
        if state == 0 {
            state0()
        } else if state == 1 {
            move()
            fire()
            
            ttimer += Model.ins.deltaTime!
            
            if ttimer >= 10 {
                state = 2
            }
        } else if state == 2 {
            state2()
        }
    }
    
    private func move() {
        if isMoving {
            if node.position.z >= -20 {
                isMoving = false
            } else {
                node.position += (targetPos - originPos).normalized() * spd * Model.ins.deltaTimeF!
            }
        }
    }
    
    private func fire() {
        fireTimer += Model.ins.deltaTime!
        
        if (fireTimer >= fireDelta) {
            let b = MachineGunBullet(selfPos: node.position)
            b.node.position = node.position
            b.node.position.z += 2
            let _ = Model.ins.addGameObject(b)
            fireTimer = 0
        }
    }
    
    private func state0() {
        iSpd += decl * Model.ins.deltaTimeF!
        node.position.y += iSpd * Model.ins.deltaTimeF!
        
        if abs(iSpd) < 0.1 {
            state = 1
        }
    }
    
    private func state2() {
        iSpd -= decl * Model.ins.deltaTimeF!
        node.position.y += iSpd * Model.ins.deltaTimeF!
        
        if node.position.y > 5 {
            Model.ins.removeGameObject(self)
        }
    }
}

class Enemy320: Enemy {
    public static var nod: SCNNode!
    
    var fireTimer = 0.0
    var fireDelta = 3.0

    var parent = Enemy(node: SCNNode(), maxHp: 5)
    var parentCurrentHp = 0
    var spd: Float = 1.0
    var isMoveUp = false

    var state = 0
    var ttimer = 0.0
    
    init() {
        super.init(node: Enemy320.nod.clone(), maxHp: 2)
    }
    
    override func start() {
        parentCurrentHp = parent.hp
    }

    override public func update() {
        if state == 0 {
            state0()
        } else if state == 1 {
            move()
            fire()
            heal()
            
            ttimer += Model.ins.deltaTime!
            
            if ttimer >= 27 {
                state = 2
            }
        } else if state == 2 {
            state2()
        }
    }

    private func heal() {
        let hppos = parentCurrentHp - parent.hp
        if hppos != 0 {
            parentCurrentHp = parent.hp
            hp += hppos
        }
    }

    private func move() {
        let upMost = parent.node.position.y + 3
        let downMost = parent.node.position.y - 3
        if isMoveUp {
            if node.position.y >= upMost {
                isMoveUp = false
            }
            node.position.y += spd * Model.ins.deltaTimeF!
        } else {
            if node.position.y <= downMost {
                isMoveUp = true
            }
            node.position.y -= spd * Model.ins.deltaTimeF!
        }
        node.position.x = parent.node.position.x
    }

    private func fire() {
        fireTimer += Model.ins.deltaTime!

        if (fireTimer >= fireDelta) {
            let b = MachineGunBullet(selfPos: node.position)
            b.node.position = node.position
            b.node.position.z += 2
            let _ = Model.ins.addGameObject(b)
            fireTimer = 0
        }
    }
    
    private func state0() {
        node.position.y -= spd * Model.ins.deltaTimeF!
        
        if abs(node.position.y) < 0.2 {
            state = 1
        }
    }
    
    private func state2() {
        node.position.y -= spd * Model.ins.deltaTimeF!
        
        if node.position.y < -5 {
            Model.ins.removeGameObject(self)
        }
    }
}

class Enemy330: Enemy {
    public static var nod: SCNNode!
    
    var playerPos = SCNVector3(0, 0, 0)
    var spd = 1.0
    var islock = false
    var dis: Float = 0.0
    
    var state = 0
    var ttimer = 0.0
    
    init() {
        super.init(node: Enemy330.nod.clone(), maxHp: 2)
    }

    override public func update() {
        if state == 0 {
            state0()
        } else if state == 1 {
            lock()
            move()
            
            ttimer += Model.ins.deltaTime!
            if ttimer > 20 {
                state = 2
            }
        } else if state == 2 {
            state2()
        }
    }

    private func lock() {
        if Int(playerPos.x) == Int(node.position.x) {
            islock = true
            dis = playerPos.distance(vector: node.position)
        }

        if islock && (playerPos.distance(vector: node.position) - dis > 0.01 || playerPos.distance(vector: node.position) - dis < -0.01) {
            fire()
        }
    }

    private func move() {
        playerPos = Model.ins.player.node.position

        let x = playerPos.x > node.position.x ? node.position.x + Float(Model.ins.deltaTime! * spd) : node.position.x - Float(Model.ins.deltaTime! * spd)
        node.position.x = x
    }

    private func fire() {
        let b = MachineGunBullet(selfPos: node.position)
        b.node.position = node.position
        b.node.position.y += 2
        let _ = Model.ins.addGameObject(b)
        islock = false
    }
    
    private func state0() {
        node.position.x -= Float(spd) * Model.ins.deltaTimeF!
        
        if abs(node.position.x) < 0.2 {
            state = 1
        }
    }
    
    private func state2() {
        node.position.x -= Float(spd) * Model.ins.deltaTimeF!
        
        if node.position.x < -10 {
            Model.ins.removeGameObject(self)
        }
    }
}

class Enemy351: Enemy {
    public static var nod: SCNNode!
    var spd: Float = 1

    var fireTimer = 0.0
    var fireDelta = 3.0

    var spawnTimer = 0.0
    var spawnDelta = 5.0

    var id1 = -1
    var id2 = -1
 
    var myPos = SCNVector3()
    var isMoveLeft = true
    var movePhase1 = true
    
    var state = 0
    var ttimer = 0.0
    var decl: Float = -1.0
    var iSpd: Float = 4.0

    init() {
        super.init(node: Enemy351.nod.clone(), maxHp: 130)
    }

    override func start() {
        myPos = node.position
    }
    
    override public func update() {
        if state == 0 {
            state0()
        } else if state == 1 {
            move()
    //        fire()
            spawn()
            
            ttimer += Model.ins.deltaTime!
            
            if ttimer >= 50 {
                state = 2
            }
        } else if state == 2 {
            state2()
        }
    }

    private func move() {
        if node.position.z >= -35 {
            movePhase1 = false
        }
        
        if movePhase1 {
            node.position.z += spd * 5 * Model.ins.deltaTimeF!
        } else {
//            let leftMost = myPos.x - 3
//            let rightMost = myPos.x + 3
//            if isMoveLeft {
//                if node.position.x <= leftMost {
//                    isMoveLeft = false
//                }
//                node.position.x -= spd * Model.ins.deltaTimeF!
//            } else {
//                if node.position.x >= rightMost {
//                    isMoveLeft = true
//                }
//                node.position.x += spd * Model.ins.deltaTimeF!
//            }
        }
    }

    private func fire() {
        fireTimer += Model.ins.deltaTime!

        if fireTimer >= fireDelta {
            let b = MachineGunBullet(selfPos: node.position)
            b.node.position = node.position
            let _ = Model.ins.addGameObject(b)
            fireTimer = 0
        }
    }

    private func spawn() {
        spawnTimer += Model.ins.deltaTime!
        
        if (spawnTimer >= spawnDelta) {
            let obj1 = Model.ins.objs[id1]
            let obj2 = Model.ins.objs[id2]
    
            if obj1 == nil {
                let enemy = Enemy330()
                enemy.node.position = node.position + SCNVector3(0, 2, 3)
                enemy.node.position.x = 10
                id1 = Model.ins.addGameObject(enemy)
            }
            if obj2 == nil {
                let enemy = Enemy320()
                enemy.node.position = node.position + SCNVector3(0, 7, 5.5)
                enemy.parent = self
                id2 = Model.ins.addGameObject(enemy)
            }
            
            spawnTimer = 0
        }
    }
    
    private func state0() {
        iSpd += decl * Model.ins.deltaTimeF!
        node.position.y += iSpd * Model.ins.deltaTimeF!
        
        if abs(node.position.y) < 0.2 {
            state = 1
        }
    }
    
    private func state2() {
        iSpd -= decl * Model.ins.deltaTimeF!
        node.position.y += iSpd * Model.ins.deltaTimeF!
        
        if node.position.y > 7 {
            Model.ins.removeGameObject(self)
        }
    }
}

class Boss436: Enemy {
    public static var nod: SCNNode!
    
    var spd: Float = 1.0
    var phase = 1
    
    var playerPos = Model.ins.player.node.position
    var myPos = SCNVector3()

    // move
    var moveTimer = 3.0
    var moveDelta = 3.0
    var dir = SCNVector3()
    var tempPos = SCNVector3()
    
    // fire
    var fireTimer = 0.3
    var fireDelta = 0.3
    
    // skill hit
    var isMoveForward = true
    var skillHitTimer = 0.0
    var skillHitDelta = 5.0
    var myTempPos = SCNVector3()

    // skill spawn 2 351s
    var id1: Int = -1
    var id2: Int = -1
    var skillSpawnTimer = 10.0
    var skillSpawnDelta = 10.0
    
    // skill spawn 4 351s
    var id3: Int = -1
    var id4: Int = -1
    var id5: Int = -1
    var id6: Int = -1
    var skillSpawn2Timer = 10.0
    var skillSpawn2Delta = 10.0
    
    // skill shoot1
    var skillShoot1Timer = 0.0
    var skillShoot1Delta = 7.0
    
    // skill shoot2
    var skillShoot2Timer = 0.0
    var skillShoot2Delta = 0.5
    
    // skill summon meteoroid
    var skillSummonMeteoroidTimer = 5.0
    var skillSummonMeteoroidDelta = 5.0
    
    // =.=
    var ttimer = 0.0
    var state = 0
    
    init() {
        super.init(node: Boss436.nod.clone(), maxHp: 300)
    }
    
    override public func start() {
        myTempPos = node.position
    }

    override public func update() {
        if state == 0 {
            state0()
            return
        }
        
        move()
        if hp >= 150 {
            fire()
            skillHit()
            //skillSpawnTwo351(pos: SCNVector3(5, 0, 0))
            skillShoot1()
        } else {
            skillSummonMeteoroid()
//            skillSpawnFour351(pos1: SCNVector3(5, 2, 0), pos2: SCNVector3(5, -2, 0))
            //skillSpawnTwo351(pos: SCNVector3(5, 0, 0))
            skillShoot2()
        }
    }
    
    private func skillSummonMeteoroid() {
        skillSummonMeteoroidTimer += Model.ins.deltaTime!
        
        if skillSummonMeteoroidTimer >= skillSummonMeteoroidDelta {
            var mSpd: Float = 0
            for _ in 0...10 {
                let m = Meteoroid()
                m.node.position = SCNVector3(Int.random(in: -3...3), Int.random(in: -3...3), -100)
                m.spd += mSpd
                let _ = Model.ins.addGameObject(m)
                mSpd += 1
            }
            
            skillSummonMeteoroidTimer = 0
        }
    }
    
    private func skillShoot2() {
        skillShoot2Timer += Model.ins.deltaTime!
        
        if skillShoot2Timer >= skillShoot2Delta {
                var b = BossBullet2()
                b.node.position = node.position + SCNVector3(-1, 0, 0)
                let _ = Model.ins.addGameObject(b)
                
                b = BossBullet2()
                b.node.position = node.position + SCNVector3(1, 0, 0)
                let _ = Model.ins.addGameObject(b)
                
                b = BossBullet2()
                b.node.position = node.position + SCNVector3(0, 1, 0)
                let _ = Model.ins.addGameObject(b)
                
                b = BossBullet2()
                b.node.position = node.position + SCNVector3(0, -1, 0)
                let _ = Model.ins.addGameObject(b)
            skillShoot2Timer = 0
            }
    }
    
    private func skillShoot1() {
        skillShoot1Timer += Model.ins.deltaTime!
        
        if skillShoot1Timer >= skillShoot1Delta {
            let n = 20
            var z: Float = 0.0
            for _ in 0..<4 {
                for i in 0..<n {
                    let u: Float = Float(i)/Float(n) * 2 * Float.pi
                    let x: Float = cos(u)
                    let y: Float = sin(u)
                    
                    let b = BossBullet1(dir: SCNVector3(x, y, z))
                    b.node.position = node.position
                    let _ = Model.ins.addGameObject(b)
                }
                z += 3
            }

            skillShoot1Timer = 0
        }
    }
    
    private func skillHit() {
        skillHitTimer += Model.ins.deltaTime!

        if skillHitTimer >= skillHitDelta {
            let targetPos: Float = -23
            if isMoveForward {
                if node.position.z <= targetPos {
                    node.position.z += 15 * spd * Model.ins.deltaTimeF!
                } else {
                    isMoveForward = false
                }
            } else {
                if node.position.z >= myTempPos.z {
                    node.position.z -= 15 * spd * Model.ins.deltaTimeF!
                } else  {
                    isMoveForward = true
                    skillHitTimer = 0
                }
            }
        }
    }
    
    private func skillSpawnTwo351(pos: SCNVector3) {
        skillSpawnTimer += Model.ins.deltaTime!
        
        if skillSpawnTimer >= skillSpawnDelta {
            let obj1 = Model.ins.objs[id1]
            let obj2 = Model.ins.objs[id2]
    
            if obj1 == nil {
                let enemy = Enemy351()
                enemy.node.position = pos + SCNVector3(0, 0, -50)
                id1 = Model.ins.addGameObject(enemy)
            }
            if obj2 == nil {
                let enemy = Enemy351()
                enemy.node.position = SCNVector3(0, 0, -50) - pos
                id2 = Model.ins.addGameObject(enemy)
            }
            
            skillSpawnTimer = 0
        }
    }
    
    private func skillSpawnFour351(pos1: SCNVector3, pos2: SCNVector3) {
        skillSpawn2Timer += Model.ins.deltaTime!
        
        if skillSpawn2Timer >= skillSpawn2Delta {
            let obj1 = Model.ins.objs[id3]
            let obj2 = Model.ins.objs[id4]
            let obj3 = Model.ins.objs[id5]
            let obj4 = Model.ins.objs[id6]
            
            if obj1 == nil {
                let enemy = Enemy351()
                enemy.node.position = SCNVector3(0, 0, -50) + pos1
                id3 = Model.ins.addGameObject(enemy)
            }
            if obj2 == nil {
                let enemy = Enemy351()
                enemy.node.position = SCNVector3(0, 0, -50) - pos1
                id4 = Model.ins.addGameObject(enemy)
            }
            if obj3 == nil {
                let enemy = Enemy351()
                enemy.node.position = SCNVector3(0, 0, -50) + pos2
                id5 = Model.ins.addGameObject(enemy)
            }
            if obj4 == nil {
                let enemy = Enemy351()
                enemy.node.position = SCNVector3(0, 0, -50) - pos2
                id6 = Model.ins.addGameObject(enemy)
            }
 
            skillSpawn2Timer = 0
        }
    }
    
    private func move() {
        moveTimer += Model.ins.deltaTime!
        
        if moveTimer >= moveDelta {
            tempPos = node.position
            dir = SCNVector3(Float.random(in: -3...3), Float.random(in: -3...3), node.position.z)
            moveTimer = 0
        }
        node.position += (dir - tempPos).normalized() * spd * Model.ins.deltaTimeF!
    }

    private func fire() {
        fireTimer += Model.ins.deltaTime!
        
        if (fireTimer >= fireDelta) {
                let b = MachineGunBullet(selfPos: node.position)
                b.node.position = node.position
                let _ = Model.ins.addGameObject(b)
            
            fireTimer = 0
        }
    }
    
    private func state0() {
        node.position.x += 3 * Model.ins.deltaTimeF!
        node.position.y += 3 * Model.ins.deltaTimeF!
        
        if abs(node.position.x) <= 0.3 {
            state = 1
        }
    }
    
    override func onDestroy() {
        DispatchQueue.main.async {
            Model.ins.cleared = true
        }
        Model.ins.gameover()
    }
}


// shiyuan duan
public class BlinkingEnemy: Enemy {
    public static var nod: SCNNode!
    
    private var spd = SCNVector3(-2, 0, 0)
    private var timer = 0.5
    private var frameCounter = 0
    private var player: Player
    init(player: Player) {
        self.player = player
//        let box = SCNBox(width: 1, height: 1, length: 1, chamferRadius: 0.1)
//        box.firstMaterial!.diffuse.contents = UIColor.yellow
//        let node = SCNNode(geometry: box)
        super.init(node:BlinkingEnemy.nod.clone(), maxHp: 1)
        node.scale = SCNVector3(2.5, 2.5, 2.5)
    }
    
    
    public override func update() {
        frameCounter += 1;
        if (frameCounter%70 == 0){
            blink();
            fire();
        }
        if(frameCounter >= 700){
            Model.ins.removeGameObject(self)
        }
    }
    
    
    private func blink(){
        let blink = Blink()
        blink.node.position = node.position
        let _ = Model.ins.addGameObject(blink)
        
        let randomX = Int.random(in: -7..<7);
        let randomY = Int.random(in: -3..<3);
        
        self.node.position = SCNVector3(randomX, randomY, -50);
    }
    
    private func fire(){
        let b = TestEnemyBullet()
        let spdX = node.position.x - player.node.position.x
        let spdY = node.position.y - player.node.position.y
        b.spd = SCNVector3(spdX, spdY, 30)
        b.node.position = node.position
        let _ = Model.ins.addGameObject(b)
        
        
    }
}

public class SentinalEnemy: Enemy{
    public static var nod: SCNNode!
    
    private var spd = SCNVector3(-2, 0, 0)
    private var timer = 0.5
    private var frameCounter = 0
    private var player: Player
    init(player: Player) {
        self.player = player
        super.init(node:SentinalEnemy.nod.clone(), maxHp: 1)
    }
    
    
    public override func update() {
        
        
        frameCounter += 1;
        if(frameCounter%100 == 0){
            changeSpd()
        }
        if (frameCounter%70 == 0){
            fire()
        }
        if(node.position.x>=7 || node.position.x <= -7){
            spd.x = spd.x * -1
        }
        if(node.position.y>=5 || node.position.y <= -4){
            spd.y = spd.y * -1
        }
        
        node.position.x += spd.x * Model.ins.deltaTimeF!
        node.position.y += spd.y * Model.ins.deltaTimeF!
        
        
        if(frameCounter >= 700){
            Model.ins.removeGameObject(self)
        }
    }
    
    public func changeSpd(){
        let spdX = Int.random(in: -5..<5)
        let spdY = Int.random(in: -5..<5)
        
        spd = SCNVector3(spdX, spdY, 0)
        
    }
    
    private func fire(){
        let b = TrackingEnemyBullet(player: player)
        let spdX = node.position.x - player.node.position.x
        let spdY = node.position.y - player.node.position.y
        b.spd = SCNVector3(spdX, spdY, 30)
        b.node.position = node.position
        let _ = Model.ins.addGameObject(b)
        
        
    }
    
    
}

public class BossEnemy: Enemy{
    public static var nod: SCNNode!
    
    private var cycleCounter = -400
    private var playerLastPosition = SCNVector3(0,0,0)
    private var player: Player
    private var normalState = true
    private var particleEffectAdded = false
    private var warningParticle = ThermalLock()
    
    init(player: Player) {
        self.player = player
        super.init(node:BossEnemy.nod.clone(), maxHp: 500)
//        node.scale = SCNVector3(0.0025, 0.0025, 0.0025)

    }
    
    public override func update() {
        print(node.boundingBox.max)
        print(node.boundingBox.min)
        print()
        
        if(cycleCounter<0){
            node.position.y -= 0.05
        }
        
        if(cycleCounter%20 == 0 && cycleCounter>0){
            if(normalState){
                fireAimedBullet()
            }
            
        }
        
        
        if(cycleCounter == 200 || cycleCounter == 400 || cycleCounter == 600){
            if(normalState){
                burst()
            }
            
        }
        
        
        if (cycleCounter >= 700 && cycleCounter < 900){
            if(!particleEffectAdded){
                particleEffectAdded.toggle()
                warningParticle.node.position = node.position
                warningParticle.node.position.z += 20
                let _ = Model.ins.addGameObject(warningParticle)
                
            }
            
            normalState = false
            playerLastPosition = player.node.position
            
        }
        if (cycleCounter >= 900){
            
            
            ultimate()
        }
        
        if(cycleCounter % 40 == 0 && cycleCounter>0){
            if(normalState){
                fireTrackBullet()
            }
            
        }
        
        if(cycleCounter == 1000){
            if(particleEffectAdded){
                particleEffectAdded.toggle()
                Model.ins.removeGameObject(warningParticle)
            }
            
            cycleCounter = 0
            normalState = true
            
        }
        
        
        
        
        cycleCounter += 1
    }
    
    private func ultimate(){
        if (player.node.position.x == playerLastPosition.x && player.node.position.y == playerLastPosition.y){
            print("safe")
            burst()
        }else{
            print("not safe")
            burstTrackedBullet()
        }
            
    }
    
    private func burstTrackedBullet(){
        //stupid implementation
        let b1 = FancyTrackingEnemyBullet(player: player)
        let b2 = FancyTrackingEnemyBullet(player: player)
        let b3 = FancyTrackingEnemyBullet(player: player)
        let b4 = FancyTrackingEnemyBullet(player: player)
        let b5 = FancyTrackingEnemyBullet(player: player)
        
        b1.spd = SCNVector3(Int.random(in: -5..<5), Int.random(in: -5..<5), 30)
        b2.spd = SCNVector3(Int.random(in: -7..<7), Int.random(in: -7..<7), 30)
        b3.spd = SCNVector3(Int.random(in: -10..<10), Int.random(in: -10..<10), 30)
        b4.spd = SCNVector3(Int.random(in: -15..<15), Int.random(in: -15..<15), 30)
        b5.spd = SCNVector3(Int.random(in: -15..<15), Int.random(in: -15..<15), 30)
        
        
        b1.node.position = node.position
        b2.node.position = node.position
        b3.node.position = node.position
        b4.node.position = node.position
        b5.node.position = node.position
        
        let _ = Model.ins.addGameObject(b1)
        let _ = Model.ins.addGameObject(b2)
        let _ = Model.ins.addGameObject(b3)
        let _ = Model.ins.addGameObject(b4)
        let _ = Model.ins.addGameObject(b5)
    }
    private func fireTrackBullet(){
        let b = TrackingEnemyBullet(player: player)
        let spdX = node.position.x - player.node.position.x
        let spdY = node.position.y - player.node.position.y
        b.spd = SCNVector3(spdX, spdY, 30)
        b.node.position = node.position
        let _ = Model.ins.addGameObject(b)
    }
    
    private func fireAimedBullet(){
        let b = TestEnemyBullet()
        let spdX = node.position.x - player.node.position.x
        let spdY = node.position.y - player.node.position.y
        b.spd = SCNVector3(spdX, spdY, 30)
        b.node.position = node.position
        let _ = Model.ins.addGameObject(b)
    }
    
    private func burst(){
        //stupid implementation
        let b1 = BurstEnemyBullet()
        let b2 = BurstEnemyBullet()
        let b3 = BurstEnemyBullet()
        let b4 = BurstEnemyBullet()
        let b5 = BurstEnemyBullet()
        
        b1.spd = SCNVector3(0, 0, 30)
        b2.spd = SCNVector3(5, 0, 30)
        b3.spd = SCNVector3(-5, 0, 30)
        b4.spd = SCNVector3(0, 5, 30)
        b5.spd = SCNVector3(0, -5, 30)
        
        
        b1.node.position = node.position
        b2.node.position = node.position
        b3.node.position = node.position
        b4.node.position = node.position
        b5.node.position = node.position
        
        let _ = Model.ins.addGameObject(b1)
        let _ = Model.ins.addGameObject(b2)
        let _ = Model.ins.addGameObject(b3)
        let _ = Model.ins.addGameObject(b4)
        let _ = Model.ins.addGameObject(b5)
    }
    
    
    
    
    
}

public class TankEnemy: Enemy {
    public static var nod: SCNNode!
    
    private var spd = SCNVector3(-2, 0, 0)
    private var timer = 0.5
    private var frameCounter = 0
    private var burstSmoke = BurstSmoke()
    
    init() {
        super.init(node:TankEnemy.nod.clone(), maxHp: 5)
        
    }
    
    public override func update() {
        
        
        frameCounter+=1
        
        timer -= Model.ins.deltaTime!
        
        if(frameCounter % 100 == 0){
            burst()
        }
        
        
        if(frameCounter >= 700){
            Model.ins.removeGameObject(self)
        }
    }
    
    
    private func burst(){
        //stupid implementation
        
        let _ = Model.ins.addGameObject(burstSmoke)
        burstSmoke.node.position = node.position
        burstSmoke.node.position.z+=3
        
        let b1 = BurstEnemyBullet()
        let b2 = BurstEnemyBullet()
        let b3 = BurstEnemyBullet()
        let b4 = BurstEnemyBullet()
        let b5 = BurstEnemyBullet()
        
        b1.spd = SCNVector3(0, 0, 30)
        b2.spd = SCNVector3(5, 0, 30)
        b3.spd = SCNVector3(-5, 0, 30)
        b4.spd = SCNVector3(0, 5, 30)
        b5.spd = SCNVector3(0, -5, 30)
        
        
        b1.node.position = node.position
        b2.node.position = node.position
        b3.node.position = node.position
        b4.node.position = node.position
        b5.node.position = node.position
        
        let _ = Model.ins.addGameObject(b1)
        let _ = Model.ins.addGameObject(b2)
        let _ = Model.ins.addGameObject(b3)
        let _ = Model.ins.addGameObject(b4)
        let _ = Model.ins.addGameObject(b5)
        
    }
}


public class BurstEnemyBullet: EnemyBullet {
    public var spd = SCNVector3(0, 0, 30)
    
    init() {
        print("bullet spawned")
        
        let box = SCNSphere(radius: 0.3)
        box.firstMaterial!.diffuse.contents = UIColor.red
        let node = SCNNode(geometry: box)
        super.init(node)

        
    }
    
    public override func update() {
        
        node.position.z += spd.z * Model.ins.deltaTimeF!
        node.position.x += spd.x * Model.ins.deltaTimeF!
        node.position.y += spd.y * Model.ins.deltaTimeF!
        
        if node.position.z > 10 {
            Model.ins.removeGameObject(self)
            print("Removed!")
        }
        
        
    }
    
    
    
}
public class TrackingEnemyBullet: EnemyBullet {
    public var spd = SCNVector3(0, 0, 30)
    private var player: Player
    private var smoke = Smoke()
    init(player: Player) {
        self.player = player
        
        
        let box = SCNSphere(radius: 0.1)
        box.firstMaterial!.diffuse.contents = UIColor.red
        let node = SCNNode(geometry: box)
        super.init(node)
        
        
        smoke.node.scale = SCNVector3(0.1,0.1,0.1)
        let _ = Model.ins.addGameObject(smoke)

        
    }
    
    public override func update() {
        smoke.node.position = node.position
        let spdX = node.position.x - player.node.position.x
        let spdY = node.position.y - player.node.position.y
        spd = SCNVector3(spdX, spdY, 30)
        
        
        node.position.z += spd.z * Model.ins.deltaTimeF!
        node.position.x -= spd.x * Model.ins.deltaTimeF! * 4
        node.position.y -= spd.y * Model.ins.deltaTimeF! * 4
        
        if node.position.z > 10 || node.position.z < -100{
            Model.ins.removeGameObject(self)
            print("Removed!")
        }
        
        
    }
    
    
    
}

public class FancyTrackingEnemyBullet: EnemyBullet {
    public var spd = SCNVector3(0, 0, 30)
    private var player: Player
    private var frameCounter = 0
//    private var smoke = Smoke()
    
    
    init(player: Player) {
        self.player = player
        
        let box = SCNSphere(radius: 0.05)
        box.firstMaterial!.diffuse.contents = UIColor.orange
        let node = SCNNode(geometry: box)
        super.init(node)
        
//        smoke.node.scale = SCNVector3(0.1,0.1,0.1)
//        let _ = Model.ins.addGameObject(smoke)

        
    }
    
    public override func update() {
//        smoke.node.position = node.position
        
        if frameCounter >= 150{
            let spdX = node.position.x - player.node.position.x
            let spdY = node.position.y - player.node.position.y
            spd = SCNVector3(spdX, spdY, 30)
            
            
            node.position.z += spd.z * Model.ins.deltaTimeF! * 10
            node.position.x -= spd.x * Model.ins.deltaTimeF! * 20
            node.position.y -= spd.y * Model.ins.deltaTimeF! * 20
            
            
        }else if(frameCounter >= 30 && frameCounter < 150){
            spd = SCNVector3(0,0,0)
        }else{
                node.position.z += spd.z * Model.ins.deltaTimeF!
                node.position.x += spd.x * Model.ins.deltaTimeF!
                node.position.y += spd.y * Model.ins.deltaTimeF!
            }
        frameCounter += 1
        if node.position.z > 10 || node.position.z < -100 {
            Model.ins.removeGameObject(self)
            print("Removed!")
        }
    }
    
    
    
}


