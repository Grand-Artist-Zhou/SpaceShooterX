//
//  HighscoreView.swift
//  SpaceShooterX
//
//  Created by Yuxuan Bu on 11/15/21.
//

import Foundation
import SwiftUI
import SceneKit

struct Score: Identifiable {
    var id: Int
    let score: Int
    let time: Date
    
    static public func <(_ s1: Score, _ s2: Score) -> Bool {
        return s1.score > s2.score
    }
}

struct HighscoreView : View {
    @EnvironmentObject var viewManager: ViewManager
    @StateObject var m = ScoreBackgroundSceneManager("ScoreScreenScene.scn", SCNVector3(0, 0, 1))
    
    @State var opacity = 0.0
    @State var cOpacity = 1.0
    
    private var scores = [Score]()
    
    // back
    @State var bDisabled = false
    
    init() {
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
    }
    
    var body: some View {
        ZStack {
            Background()
            
            SceneView(
                scene: m.scene,
                options: [
                    //.allowsCameraControl,
                    //.autoenablesDefaultLighting,
                    .rendersContinuously
                ]
            )
                .frame(width: 1000, height: 1000)
            
            Button {
                bDisabled = true
                opacity = 1
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.7) {
                    viewManager.view = .TitleScreen
                }
            } label: {
                Image(systemName: "arrowshape.turn.up.backward.fill")
                    .foregroundColor(.white)
                    .scaleEffect(2.5)
            }
                .disabled(bDisabled)
                .position(x: 180, y: 380)
            
            VStack {
                Text("High Score")
                    .font(.system(size: 40))
                    .foregroundColor(.white)
                
                ZStack {
                    Rectangle()
                        .foregroundColor(Color(.sRGB, red: 1, green: 1, blue: 1, opacity: 0.1))
                        .frame(width: 400, height: 220)
                    
                    VStack(spacing: 20) {
                        ForEach(scores) { s in
                            HStack {
                                Text(String(s.score))
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Spacer()
                                Text(s.time.description)
                                    .font(.headline)
                                    .foregroundColor(.white)
                            }
                        }
                    }
                    .frame(width: 380, height: 200)
                }
            }
            
            Rectangle()
                .foregroundColor(Color(.sRGB, red: 0, green: 0, blue: 0, opacity: opacity))
                .frame(width: 1000, height: 1000)
                .animation(.easeInOut(duration: 1.5))
            
            Rectangle()
                .foregroundColor(Color(.sRGB, red: 0, green: 0, blue: 0, opacity: cOpacity))
                .frame(width: 1000, height: 1000)
                .onAppear() {
                    cOpacity = 0
                }
                .animation(.easeInOut(duration: 1.5).delay(1))
        }
    }
}
