//
//  TestSceneView.swift
//  SpaceShooterX
//
//  Created by Yuxuan Bu on 11/1/21.
//

import Foundation
import SwiftUI
import SceneKit


struct Level1View: View {
    @StateObject var model = Level1()
    
    // curtain
    @State var cOpacity = 1.0
    
    // dpad
    @State var dpadPos = CGPoint()
    @State var show = false
    
    // fire button
    @State var strokeColor = Color.white
    
    var body: some View {
        
        ZStack {
            SceneView(
                scene: model.myScene,
                pointOfView: model.myCamera,
                options: [
                    //.allowsCameraControl,
                    .autoenablesDefaultLighting,
                    .rendersContinuously
                ],
                delegate: model.myScene
            )
                .frame(width: 1000, height: 1000)
                .simultaneousGesture(
                    DragGesture(minimumDistance: 1)
                        .onChanged() { spd in
                            var dx = spd.location.x - spd.startLocation.x
                            var dy = spd.location.y - spd.startLocation.y
                            
                            dx = min(75, abs(dx)) * (dx > 0 ? 1 : -1)
                            dy = min(75, abs(dy)) * (dy > 0 ? 1 : -1)
                            model.playerMove(CGPoint(x:dx, y:dy))
                            show = true
                            dpadPos = spd.startLocation
                        }
                        .onEnded() { _ in
                            model.playerMove(CGPoint(x: 0, y: 0))
                            show = false
                        }
                )
            
            // Curtain
            Rectangle()
                .foregroundColor(Color(.sRGB, red: 0, green: 0, blue: 0, opacity: cOpacity))
                .frame(width: 1000, height: 1000)
                .onAppear() {
                    cOpacity = 0
                }
                .animation(.easeInOut(duration: 1))
        
            // hp bar
            HStack {
                Rectangle()
                    .foregroundColor(Color(.sRGB, red: 1, green: 0, blue: 0, opacity: 0.3))
                    .frame(width: 200, height: 7, alignment: .leading)
                    .scaleEffect(CGSize(width: max(Double(model.php), 0) / 5.0, height: 1.0), anchor: .leading)
                    .animation(.easeInOut)
            }
            .position(x: 300, y: 650)
            
            // score
            Text(String(model.score))
                .foregroundColor(Color.white)
                .font(.system(size: 15))
                .frame(width: 300, height: 20, alignment: .trailing)
                .position(x: 600, y: 400)
             
            
            // dpad
            if (show) {
                Circle()
                    .stroke(.gray, lineWidth: 1.5)
                    .frame(width: 140, height: 140)
                    .position(x: dpadPos.x, y: dpadPos.y)
            }
            
            // fire button
            ZStack {
                Circle()
                    .stroke(strokeColor, lineWidth: 1)
                    .background(Circle().fill(Color(red: 1, green: 1, blue: 1, opacity: 0.01)))
                    .frame(width: 70, height: 70)
                Text("F")
                    .foregroundColor(strokeColor)
            }
            .position(x: 720, y: 600)
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged() { _ in
                        strokeColor = Color.red
                        model.playerFire(true)
                    }
                    .onEnded() { _ in
                        strokeColor = Color.white
                        model.playerFire(false)
                    }
            )
        }
        .background(Color.black)
        
    }
}


struct Level2View: View {
    @StateObject var model = Level2()
    
    // curtain
    @State var cOpacity = 1.0
    
    // dpad
    @State var dpadPos = CGPoint()
    @State var show = false
    
    // fire button
    @State var strokeColor = Color.white
    
    var body: some View {
        
        ZStack {
            SceneView(
                scene: model.myScene,
                pointOfView: model.myCamera,
                options: [
                    //.allowsCameraControl,
                    .autoenablesDefaultLighting,
                    .rendersContinuously
                ],
                delegate: model.myScene
            )
                .frame(width: 1000, height: 1000)
                .simultaneousGesture(
                    DragGesture(minimumDistance: 1)
                        .onChanged() { spd in
                            var dx = spd.location.x - spd.startLocation.x
                            var dy = spd.location.y - spd.startLocation.y
                            
                            dx = min(75, abs(dx)) * (dx > 0 ? 1 : -1)
                            dy = min(75, abs(dy)) * (dy > 0 ? 1 : -1)
                            model.playerMove(CGPoint(x:dx, y:dy))
                            show = true
                            dpadPos = spd.startLocation
                        }
                        .onEnded() { _ in
                            model.playerMove(CGPoint(x: 0, y: 0))
                            show = false
                        }
                )
            
            // Curtain
            Rectangle()
                .foregroundColor(Color(.sRGB, red: 0, green: 0, blue: 0, opacity: cOpacity))
                .frame(width: 1000, height: 1000)
                .onAppear() {
                    cOpacity = 0
                }
                .animation(.easeInOut(duration: 1))
        
            // hp bar
            HStack {
                Rectangle()
                    .foregroundColor(Color(.sRGB, red: 1, green: 0, blue: 0, opacity: 0.3))
                    .frame(width: 200, height: 7, alignment: .leading)
                    .scaleEffect(CGSize(width: max(Double(model.php), 0) / 5.0, height: 1.0), anchor: .leading)
                    .animation(.easeInOut)
            }
            .position(x: 300, y: 650)
            
            // score
            Text(String(model.score))
                .foregroundColor(Color.white)
                .font(.system(size: 15))
                .frame(width: 300, height: 20, alignment: .trailing)
                .position(x: 600, y: 400)
             
            
            // dpad
            if (show) {
                Circle()
                    .stroke(.gray, lineWidth: 1.5)
                    .frame(width: 140, height: 140)
                    .position(x: dpadPos.x, y: dpadPos.y)
            }
            
            // fire button
            ZStack {
                Circle()
                    .stroke(strokeColor, lineWidth: 1)
                    .background(Circle().fill(Color(red: 1, green: 1, blue: 1, opacity: 0.01)))
                    .frame(width: 70, height: 70)
                Text("F")
                    .foregroundColor(strokeColor)
            }
            .position(x: 720, y: 600)
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged() { _ in
                        strokeColor = Color.red
                        model.playerFire(true)
                    }
                    .onEnded() { _ in
                        strokeColor = Color.white
                        model.playerFire(false)
                    }
            )
        }
        .background(Color.black)
        
    }
}
