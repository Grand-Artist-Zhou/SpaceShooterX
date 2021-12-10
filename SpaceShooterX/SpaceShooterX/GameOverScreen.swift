//
//  TitleView.swift
//  SpaceShooterX
//
//  Created by Yuxuan Bu on 11/9/21.
//

import Foundation
import SwiftUI
import SceneKit

struct GameOverScreen: View {
    @EnvironmentObject var viewManager: ViewManager
    @State var opacity = 0.0
    @State var cOpacity = 1.0
    @State var disabled = false
    private let score: Int
    
    init() {
        score = UserDefaults.standard.integer(forKey: "tempScore")
    }
    
    var body: some View {
        ZStack {
            Background()
            
            Text(Model.ins.cleared ? "Level Cleared!" : "Game Over")
                .font(.system(size: 50))
                .foregroundColor(.white)
                .position(x: 500, y: 410)
            
            Text("Score: " + String(score))
                .font(.system(size: 25))
                .foregroundColor(.white)
                .position(x: 500, y: 490)
            
            
            Button {
                opacity = 1
                disabled = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.7) {
                    viewManager.view = .TitleScreen
                }
            } label: {
                Text("Title Screen")
                    .font(.system(size: 30))
                    .foregroundColor(.white)
            }
            .position(x: 500, y: 580)
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
                .animation(.easeInOut(duration: 1.5))
        }
    }
}

