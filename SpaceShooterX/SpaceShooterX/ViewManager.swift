//
//  ViewManager.swift
//  SpaceShooterX
//
//  Created by Yuxuan Bu on 11/9/21.
//

import Foundation

enum ViewName {
    case TitleScreen
    case TestLevel
    case Level1
    case Level2
    case HighscoreView
    case GameOver
}

class ViewManager: ObservableObject {
    public static var ins: ViewManager!
    
    @Published var view = ViewName.TitleScreen
    
    init() {
        ViewManager.ins = self
    }
}
