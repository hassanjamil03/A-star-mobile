//
//  ContentView.swift
//  Test project
//
//  Created by Hassan Jamil on 2021-12-19.
//

import SwiftUI
import Combine

struct ContentView: View {
    // the grid of nodes
    var nodes = buildNodes(numOfNodes: 4)
    
    // toggle that triggers when the algorithm runs
    @State var runAlgo = false
    
    var body: some View {
        VStack {
            ZStack {
                if !runAlgo {
                    VStack(alignment: .center, spacing: 0.0) {
                        // processing row by row in VStack
                        ForEach(nodes, id: \.self) { row in
                            HStack(alignment: .center, spacing: 0.0) {
                                // rendering each node in the row in HStack
                                ForEach(row, id: \.nodeNum) { node in
                                    node
                                }
                            }
                        }
                    }
                }
                else {
                    RenderNodes(grid: nodes)
                }
            }
            Button(action: { runAlgo.toggle() }, label: { Text("Start!") })
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



// doing this so that changes to "state" can be tracked and updated across whole app
class NodeState: ObservableObject {
    @Published var name:String = "untouched"
    
}

public var tapCount:Int = 0


// defining what an HNode is
struct HNode: View, Hashable {
    
    // defining equality for an HNode so HNode conforms to 'Equatable'
    static func == (lhs: HNode, rhs: HNode) -> Bool {
        return (lhs.nodeNum == rhs.nodeNum) &&
            (lhs.posn == rhs.posn)
    }
    
    // defining hash to HNode conforms to 'Hashable'
    func hash(into hasher: inout Hasher) {
        hasher.combine(nodeNum)
    }
    
    
    // VALUES FOR RENDERING NODE
    
    // unique identifier associated with this node
    let nodeNum = UUID()
    
    // the position of this node
    var posn:(Int,Int) = (0,0)
    
    // total number of nodes in scene, needed to figure out sizing of node
    var numberOfNodes:Int = 0
    
    
    
    // VALUES FOR RUNNING ALGORITHM ON NODE
    
    // the preceding node in the path so far, stored as tuple, representing posn of node, initialized at 0,0 so xcode isnt mad at me
    var precedingNode:(Int,Int) = (0,0)
    
    // GCost, distance from starting node, initialized at 0.0
    var GCost:Double = 0.0
    
    // HCost, euclidean distance from end node, initialized at 0.0
    var HCost:Double = 0.0
    
    // FCost, result of adding HCost and GCost
    var FCost:Double = 0.0
    
    // State, represents whether the node is barrier, untouched, start, or end.
    @ObservedObject var state = NodeState()
    
    
    // creates the View assiciated with node
    var body: some View {
        Button(action: {
            if self.state.name == "untouched" {
                if tapCount == 0 {
                    self.state.name = "start"
                } else if tapCount == 1 {
                    self.state.name = "end"
                } else {
                    self.state.name = "barrier"
                }
                tapCount += 1
            }
            else {
                self.state.name = "untouched"
                if tapCount > 0 {
                    tapCount -= 1
                }
            }
                
            }, label: {
                ZStack {
                    Image(self.state.name)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: Dimension(num: numberOfNodes),
                                   height: Dimension(num: numberOfNodes))
                    VStack {
                        Text(String(posn.0) + "," + String(posn.1))
                        Text(String(tapCount))
                    }
                }
                
        })
        
    }
    
    // calculates the dimensions of node given number of total nodes on scene
    func Dimension(num:Int) -> CGFloat {
        return (UIScreen.screenWidth/CGFloat(num).rounded(.up))
    }
    
    // calculates all three costs of curent node given list of nodes, starting node, and end node
    func CalculateCosts(endNode:HNode, parentNode:HNode) -> HNode {
        
        var currentNode:HNode = self
        
        currentNode.GCost = parentNode.GCost + tupleDist(t1: currentNode.posn, t2: parentNode.posn)
        
        currentNode.HCost = tupleDist(t1: currentNode.posn, t2: endNode.posn)
        
        currentNode.FCost = currentNode.GCost + currentNode.HCost
        
        return currentNode
    }
    
    
}




