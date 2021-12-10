//
//  ContentView.swift
//  Test
//
//  Created by Yuxuan Bu on 10/3/21.
//

import SwiftUI
import SceneKit
import CoreData

struct ContentView: View {
    @EnvironmentObject var viewManager: ViewManager
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        if viewManager.view == .TitleScreen {
            TitleView()
        } else if viewManager.view == .HighscoreView {
            HighscoreView().environment(\.managedObjectContext, viewContext)
        } else if viewManager.view == .GameOver {
            GameOverScreen()
        } else if viewManager.view == .Level1 {
            Level1View()
        } else if viewManager.view == .Level2 {
            Level2View()
        }
        else {
            Text("Error!!!")
        }
    }
}
