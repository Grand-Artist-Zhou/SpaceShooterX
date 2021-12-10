//
//  TitleView.swift
//  SpaceShooterX
//
//  Created by Yuxuan Bu on 11/9/21.
//

import Foundation
import SwiftUI
import SceneKit

struct TitleView: View {
    @EnvironmentObject var viewManager: ViewManager
    @State var opacity = 0.0
    @State var cOpacity = 1.0
    @State var disabled = false
    @StateObject var m = BackgroundSceneManager()
    
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
                opacity = 1
                disabled = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.7) {
                    viewManager.view = .Level1
                }
            } label: {
                Text("Level 1")
                    .font(.system(size: 28))
                    .foregroundColor(.white)
            }
            .position(x: 250, y: 500)
            .disabled(disabled)
            
            Button {
                opacity = 1
                disabled = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.7) {
                    viewManager.view = .Level2
                }
            } label: {
                Text("Level 2")
                    .font(.system(size: 28))
                    .foregroundColor(.white)
            }
            .position(x: 250, y: 550)
            .disabled(disabled)
            
            Button {
                opacity = 1
                disabled = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.7) {
                    viewManager.view = .HighscoreView
                }
            } label: {
                Text("High Score")
                    .font(.system(size: 22))
                    .foregroundColor(.white)
            }
            .position(x: 250, y: 600)
            .disabled(disabled)
            
            
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

