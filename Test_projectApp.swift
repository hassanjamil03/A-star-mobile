//
//  Test_projectApp.swift
//  Test project
//
//  Created by Hassan Jamil on 2021-12-19.
//

import SwiftUI

@main
struct Test_projectApp: App {
    
    @State var gridSize:Int = 4
    
    var body: some Scene {
        WindowGroup {
            VStack {
                Stepper("Grid size: \(gridSize)", value: $gridSize, in: 2...20, step: 1)
                ContentView(nodes: buildNodes(numOfNodes: gridSize))
            }
        }
    }
}
// testing another commit, should show up
 
