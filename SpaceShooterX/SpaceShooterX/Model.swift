//
//  Model.swift
//  Test
//
//  Created by Yuxuan Bu on 10/20/21.
//

import Foundation
import SceneKit

// Game Loop + Physics
extension SCNScene: SCNSceneRendererDelegate, SCNPhysicsContactDelegate {
    public func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        //print(Model.ins.php)
        if let tl = Model.ins.timeLast {
            Model.ins.deltaTime = time - tl
            Model.ins.deltaTimeF = Float(Model.ins.deltaTime!)
        } else {
            Model.ins.deltaTime = 0
            Model.ins.deltaTimeF = 0
        }
        
        Model.ins.timeLast = time
        
        for (_, va) in Model.ins.objs {
            va.update()
        }
    }
    
    public func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        if let go1 = Model.ins.objs[Int(contact.nodeA.name!)!],
            let go2 = Model.ins.objs[Int(contact.nodeB.name!)!] {
            
            
            if go1.tag == .PlayerBullet && go2.tag == .Enemy {
                Model.ins.removeGameObject(go1)
                if let e = go2 as? Enemy {
                    e.hurt()
                }
            } else if go2.tag == .PlayerBullet && go1.tag == .Enemy {
                Model.ins.removeGameObject(go2)
                if let e = go1 as? Enemy {
                    e.hurt()
                }
            } else if go1.tag == .EnemyBullet && go2.tag == .Player {
                Model.ins.removeGameObject(go1)
                Model.ins.player.hurt(1)
            } else if go1.tag == .Player && go2.tag == .EnemyBullet {
                Model.ins.removeGameObject(go2)
                Model.ins.player.hurt(1)
            } else if go1.tag == .Enemy && go2.tag == .Player {
                Model.ins.player.hurt(100)
            } else if go1.tag == .Player && go2.tag == .Enemy {
                Model.ins.player.hurt(100)
            }
        
        }
        
    }
}

public enum Tag: Int {
    case Player = 1
    case Enemy
    case PlayerBullet
    case EnemyBullet
    case Other
}

public class GameObject {
    public var node: SCNNode
    public let id: Int
    public var tag = Tag.Other
    
    init(_ node: SCNNode) {
        self.node = node
        self.id = Model.objId
        Model.objId += 1
        node.name = String(self.id)
    }
    
    public func start() {}
    public func update() {}
}

class Skybox: GameObject {
    
    override init(_ node: SCNNode) {
        super.init(node)
        //node.position.z = -40
    }
    
    override func update() {
        node.eulerAngles.x += Model.ins.deltaTimeF! * 0.004
        node.eulerAngles.y += Model.ins.deltaTimeF! * -0.004
        node.eulerAngles.z += Model.ins.deltaTimeF! * -0.004
    }
}

class Model : ObservableObject {
    public static var ins: Model!
    
    public var waveManager: WaveManager!
    
    public static var objId = 0
    public var objs = Dictionary<Int, GameObject>()
    public var deltaTime: Double?
    public var deltaTimeF: Float?
    public var timeLast: Double?
    public var myScene: SCNScene!
    public var myCamera: SCNNode!
    public var skybox: Skybox!
    public var player: Player!
    @Published public var php = 5
    @Published public var score = 0
    @Published public var cleared = false
    
    init() {
        Model.ins = self
        
        loadModels()
        player = Player()
        
        // Setting Camera
        myScene = SCNScene()
        myScene.physicsWorld.contactDelegate = myScene
        myScene.background.contents = UIColor.black
        
        
        let skybox = SCNScene(named: "skybox.scn")!.rootNode.childNode(withName: "skybox", recursively: true)
        self.skybox = Skybox(skybox!)
        let _ = addGameObject(self.skybox)
        
        myCamera = SCNNode()
        myCamera.camera = SCNCamera()
        myCamera.position = SCNVector3(0, 0, 10)
        let _ = addNode(myCamera)
        
        // Adding Lights
        let myLight1 = SCNNode()
        myLight1.light = SCNLight()
        myLight1.light!.type = .directional
        myLight1.light!.color = UIColor(white: 1.0, alpha: 0.3)
        myLight1.eulerAngles = SCNVector3(0, 0, Float.pi / 4)
        
        let _ = addGameObject(player)
        let _ = addNode(myLight1)
        
        // Creating Waves
        //var w = [Wave]()
        //w.append(Wave(obj: Boss436(), time: 3, pos: SCNVector3(-15, -15, -50)))
        //w.append(Wave(obj: TestEnemy(), time: 5, pos: SCNVector3(7, 2, -8)))
        //w.append(Wave(obj: TestEnemy(), time: 7, pos: SCNVector3(7, -2, -8)))
        //waveManager = WaveManager(w)
        //player.hp = 1
        
        // 216 y - 8
        // 320 y + 5
        // 330 x + 10
        // 351 y - 8
        // 436 xy - 30
        
        //gameWaves()
        cleared = false
    }
    
    private func loadModels() {
        let tmp = SCNScene(named: "Models.scn")
        Player.pm = tmp?.rootNode.childNode(withName: "player", recursively: true)!
        Bullet.bulletNode = tmp?.rootNode.childNode(withName: "player bullet", recursively: true)
        Meteoroid.nod = tmp?.rootNode.childNode(withName: "meteo", recursively: true)
        Enemy216.nod = tmp?.rootNode.childNode(withName: "216", recursively: true)
        Enemy320.nod = tmp?.rootNode.childNode(withName: "320", recursively: true)
        Enemy330.nod = tmp?.rootNode.childNode(withName: "330", recursively: true)
        Enemy351.nod = tmp?.rootNode.childNode(withName: "351", recursively: true)
        Boss436.nod = tmp?.rootNode.childNode(withName: "436", recursively: true)
        BlinkingEnemy.nod = tmp?.rootNode.childNode(withName: "Blinker", recursively: true)
        SentinalEnemy.nod = tmp?.rootNode.childNode(withName: "Sentinal", recursively: true)
        BossEnemy.nod = tmp?.rootNode.childNode(withName: "Warden", recursively: true)
        TankEnemy.nod = tmp?.rootNode.childNode(withName: "Spectre", recursively: true)
        
        let trailScene = SCNScene(named: "Trail.scn")
        Explosion.explNode = trailScene?.rootNode.childNode(withName: "Explosion", recursively: true)
        Blink.nod = trailScene?.rootNode.childNode(withName: "Blink", recursively: true)
        Smoke.nod = trailScene?.rootNode.childNode(withName: "Smoke", recursively: true)
        BurstSmoke.nod = trailScene?.rootNode.childNode(withName: "BurstSmoke", recursively: true)
        ThermalLock.nod = trailScene?.rootNode.childNode(withName: "thermalLock", recursively: true)
    }
    
    public func addNode(_ node: SCNNode) -> GameObject {
        myScene.rootNode.addChildNode(node)
        let obj = GameObject(node)
        objs[obj.id] = obj
        obj.start()
        
        return obj
    }
    
    public func addGameObject(_ obj: GameObject) -> Int {
        myScene.rootNode.addChildNode(obj.node)
        objs[obj.id] = obj
        obj.start()
        
        return obj.id
    }
    
    public func removeGameObject(_ obj: GameObject) {
        if objs[obj.id] != nil {
            objs[obj.id]!.node.removeFromParentNode()
            objs[obj.id] = nil
        }
    }
    
    public func playerMove(_ spd: CGPoint) {
        player.spd = spd
    }
    
    public func playerFire(_ fire: Bool) {
        player.firing = fire
    }
    
    public func gameover() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            ViewManager.ins.view = .GameOver
            UserDefaults.standard.set(self.score, forKey: "tempScore")
            
            var scores = [Score]()
            for i in 1...3 {
                let key1 = "score" + String(i)
                let key2 = "time" + String(i)
                if let s = UserDefaults.standard.object(forKey: key1), let t = UserDefaults.standard.object(forKey: key2) {
                    let sc = s as! Int
                    let tim = t as! Double
                    let tmp = Date(timeIntervalSinceReferenceDate: tim)
                    scores.append(Score(id: i, score: sc, time: tmp))
                } else {
                    let tmp = Date()
                    UserDefaults.standard.set(0, forKey: key1)
                    UserDefaults.standard.set(tmp.timeIntervalSinceReferenceDate, forKey: key2)
                    scores.append(Score(id: i, score: 0, time: tmp))
                }
            }
            
            scores.append(Score(id: 4, score: self.score, time: Date()))
            scores.sort(by: <)
            for i in 1..<3 {
                let key1 = "score" + String(i)
                let key2 = "time" + String(i)
                UserDefaults.standard.set(scores[i-1].score, forKey: key1)
                UserDefaults.standard.set(scores[i-1].time.timeIntervalSinceReferenceDate, forKey: key2)
            }
        }
    }
}

class Level1: Model {
    override init() {
        super.init()
        
        gameWaves()
    }
    
    
    public func gameWaves() {
        player.hp = 1000 // test-mode

        var w = [Wave]()

        w.append(Wave(obj: Meteoroid(), time: 1, pos: SCNVector3(x: -5, y: 2, z: -50)))
        w.append(Wave(obj: Meteoroid(), time: 1, pos: SCNVector3(x: -5, y: 2, z: -50)))
        w.append(Wave(obj: Meteoroid(), time: 1, pos: SCNVector3(x: 0, y: 2, z: -50)))
        w.append(Wave(obj: Meteoroid(), time: 1, pos: SCNVector3(x: 5, y: 2, z: -50)))

        w.append(Wave(obj: Meteoroid(), time: 3, pos: SCNVector3(x: -5, y: 2, z: -50)))
        w.append(Wave(obj: Meteoroid(), time: 3, pos: SCNVector3(x: 5, y: 2, z: -50)))
        w.append(Wave(obj: Meteoroid(), time: 3, pos: SCNVector3(x: -5, y: -2, z: -50)))
        w.append(Wave(obj: Meteoroid(), time: 3, pos: SCNVector3(x: 5, y: -2, z: -50)))

        w.append(Wave(obj: Meteoroid(), time: 5, pos: SCNVector3(x: -3, y: 3, z: -50)))
        w.append(Wave(obj: Meteoroid(), time: 5, pos: SCNVector3(x: 0, y: 3, z: -50)))
        w.append(Wave(obj: Meteoroid(), time: 5, pos: SCNVector3(x: 3, y: 3, z: -50)))
        w.append(Wave(obj: Meteoroid(), time: 5, pos: SCNVector3(x: -3, y: 0, z: -50)))
        w.append(Wave(obj: Meteoroid(), time: 5, pos: SCNVector3(x: 3, y: 0, z: -50)))
        w.append(Wave(obj: Meteoroid(), time: 5, pos: SCNVector3(x: -3, y: -3, z: -50)))
        w.append(Wave(obj: Meteoroid(), time: 5, pos: SCNVector3(x: 0, y: -3, z: -50)))
        w.append(Wave(obj: Meteoroid(), time: 5, pos: SCNVector3(x: 3, y: -3, z: -50)))

        w.append(Wave(obj: Meteoroid(), time: 7, pos: SCNVector3(x: -3, y: -3, z: -50)))
        w.append(Wave(obj: Meteoroid(), time: 7, pos: SCNVector3(x: 0, y: -3, z: -50)))
        w.append(Wave(obj: Meteoroid(), time: 7, pos: SCNVector3(x: 3, y: -3, z: -50)))
        w.append(Wave(obj: Meteoroid(), time: 7, pos: SCNVector3(x: -3, y: 3, z: -50)))
        w.append(Wave(obj: Meteoroid(), time: 7, pos: SCNVector3(x: 0, y: 3, z: -50)))
        w.append(Wave(obj: Meteoroid(), time: 7, pos: SCNVector3(x: 3, y: 3, z: -50)))

        w.append(Wave(obj: Meteoroid(), time: 9, pos: SCNVector3(x: -3, y: 0, z: -50)))
        w.append(Wave(obj: Meteoroid(), time: 9, pos: SCNVector3(x: 0, y: 3, z: -50)))
        w.append(Wave(obj: Meteoroid(), time: 9, pos: SCNVector3(x: 0, y: -3, z: -50)))
        w.append(Wave(obj: Meteoroid(), time: 9, pos: SCNVector3(x: 3, y: 0, z: -50)))
        
        var t: Double = 11
        for _ in 0...25 {
            for _ in 0...Int.random(in: 1...8) {
                let m = Meteoroid()
                m.spd = Float.random(in: 15...20)
                w.append(Wave(obj: m, time: t, pos: SCNVector3(x: Float.random(in: -6...6), y: Float.random(in: -4...4), z: -50)))
            }
            t += 1
        }

        w.append(Wave(obj: Enemy351(), time: 27, pos: SCNVector3(x: -5, y: -8, z: -70)))
        w.append(Wave(obj: Enemy351(), time: 27, pos: SCNVector3(x: 5, y: -8, z: -70)))

        func 😀(t: Double, x: Float, y: Float) {
            var i = x
            for _ in 0..<3 {
                let obj = Enemy216()
                obj.targetPos = SCNVector3(x: i, y: y, z: -20)
                w.append(Wave(obj: obj, time: t, pos: SCNVector3(x: i, y: y - 10, z: -30)))

                i += 2
            }
        }

        😀(t: 39, x: -3, y: -1)
        😀(t: 46, x: -3, y: -0)
        😀(t: 53, x: -3, y: 1)
        
        // boss fight
        w.append(Wave(obj: Boss436(), time: 85, pos: SCNVector3(x: -30, y: -30, z: -50)))
        
        waveManager = WaveManager(w)
        let _ = addGameObject(waveManager)
    }


}


class Level2: Model {
    override init() {
        super.init()
        
        gameWaves()
    }
    
    
    public func gameWaves() {
        player.hp = 1000 // test-mode

        var w = [Wave]()
    
        w.append(Wave(obj: BlinkingEnemy(player: player), time: 3, pos: SCNVector3(3, 2, -50)));
        w.append(Wave(obj: BlinkingEnemy(player: player), time: 3, pos: SCNVector3(5, 3, -50)));
        w.append((Wave(obj: SentinalEnemy(player: player), time: 4, pos: SCNVector3(Int.random(in: -7..<7), Int.random(in: -4..<4), -30))))

        w.append(Wave(obj: BlinkingEnemy(player: player), time: 6, pos: SCNVector3(3, 2, -50)));
        w.append(Wave(obj: BlinkingEnemy(player: player), time: 6, pos: SCNVector3(5, 3, -50)));
        w.append((Wave(obj: SentinalEnemy(player: player), time: 6, pos: SCNVector3(Int.random(in: -7..<7), Int.random(in: -4..<4), -30))))
        w.append((Wave(obj: SentinalEnemy(player: player), time: 10, pos: SCNVector3(Int.random(in: -7..<7), Int.random(in: -4..<4), -30))))
        w.append((Wave(obj: SentinalEnemy(player: player), time: 10, pos: SCNVector3(Int.random(in: -7..<7), Int.random(in: -4..<4), -30))))
        w.append((Wave(obj: SentinalEnemy(player: player), time: 10, pos: SCNVector3(Int.random(in: -7..<7), Int.random(in: -4..<4), -30))))

        w.append((Wave(obj: TankEnemy(), time: 12, pos: SCNVector3(Int.random(in: -7..<7), Int.random(in: -4..<4), -50))))

        w.append(Wave(obj: BlinkingEnemy(player: player), time: 15, pos: SCNVector3(3, 2, -50)));
        w.append(Wave(obj: BlinkingEnemy(player: player), time: 15, pos: SCNVector3(5, 3, -50)));

        w.append((Wave(obj: TankEnemy(), time: 20, pos: SCNVector3(Int.random(in: -7..<7), Int.random(in: -4..<4), -50))))
        w.append((Wave(obj: TankEnemy(), time: 20, pos: SCNVector3(Int.random(in: -7..<7), Int.random(in: -4..<4), -50))))
        w.append((Wave(obj: SentinalEnemy(player: player), time: 20, pos: SCNVector3(Int.random(in: -7..<7), Int.random(in: -4..<4), -30))))


        w.append(Wave(obj: BlinkingEnemy(player: player), time: 23, pos: SCNVector3(3, 2, -50)));
        w.append(Wave(obj: BlinkingEnemy(player: player), time: 23, pos: SCNVector3(5, 3, -50)));
        w.append((Wave(obj: SentinalEnemy(player: player), time: 24, pos: SCNVector3(Int.random(in: -7..<7), Int.random(in: -4..<4), -30))))

        w.append(Wave(obj: BlinkingEnemy(player: player), time: 26, pos: SCNVector3(3, 2, -50)));
        w.append(Wave(obj: BlinkingEnemy(player: player), time: 26, pos: SCNVector3(5, 3, -50)));
        w.append((Wave(obj: SentinalEnemy(player: player), time: 26, pos: SCNVector3(Int.random(in: -7..<7), Int.random(in: -4..<4), -30))))
        w.append((Wave(obj: SentinalEnemy(player: player), time: 30, pos: SCNVector3(Int.random(in: -7..<7), Int.random(in: -4..<4), -30))))
        w.append((Wave(obj: SentinalEnemy(player: player), time: 30, pos: SCNVector3(Int.random(in: -7..<7), Int.random(in: -4..<4), -30))))
        w.append((Wave(obj: SentinalEnemy(player: player), time: 30, pos: SCNVector3(Int.random(in: -7..<7), Int.random(in: -4..<4), -30))))

        w.append((Wave(obj: TankEnemy(), time: 32, pos: SCNVector3(Int.random(in: -7..<7), Int.random(in: -4..<4), -50))))

        w.append(Wave(obj: BlinkingEnemy(player: player), time: 35, pos: SCNVector3(3, 2, -50)));
        w.append(Wave(obj: BlinkingEnemy(player: player), time: 35, pos: SCNVector3(5, 3, -50)));

        w.append((Wave(obj: TankEnemy(), time: 40, pos: SCNVector3(Int.random(in: -7..<7), Int.random(in: -4..<4), -50))))
        w.append((Wave(obj: TankEnemy(), time: 40, pos: SCNVector3(Int.random(in: -7..<7), Int.random(in: -4..<4), -50))))
        w.append((Wave(obj: SentinalEnemy(player: player), time: 40, pos: SCNVector3(Int.random(in: -7..<7), Int.random(in: -4..<4), -30))))


        w.append((Wave(obj: SentinalEnemy(player: player), time: 45, pos: SCNVector3(Int.random(in: -7..<7), Int.random(in: -4..<4), -30))))
        w.append((Wave(obj: SentinalEnemy(player: player), time: 45, pos: SCNVector3(Int.random(in: -7..<7), Int.random(in: -4..<4), -30))))
        w.append((Wave(obj: SentinalEnemy(player: player), time: 45, pos: SCNVector3(Int.random(in: -7..<7), Int.random(in: -4..<4), -30))))


        w.append((Wave(obj: TankEnemy(), time: 50, pos: SCNVector3(Int.random(in: -7..<7), Int.random(in: -4..<4), -50))))
        w.append((Wave(obj: TankEnemy(), time: 55, pos: SCNVector3(Int.random(in: -7..<7), Int.random(in: -4..<4), -50))))


        w.append(Wave(obj: BossEnemy(player: player), time: 65, pos: SCNVector3(0, 24, -50)))

        waveManager = WaveManager(w)
        let _ = addGameObject(waveManager)
    }


}
