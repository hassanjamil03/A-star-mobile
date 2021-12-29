//
//  RenderFile.swift
//  Test project
//
//  Created by Hassan Jamil on 2021-12-24.
//

import Foundation
import SwiftUI


// renders x:Int amount of nodes in VStack
func RenderNodes(grid:[[HNode]]) -> some View {
    // retrieving the grid of nodes. assumed that all nodes already have states initialized. 
    let nodes:[[HNode]] = grid
    
    // setting the start and end goal variables
    let startNode:HNode = findState(nodes: nodes, state: "start")[0]
    let endNode:HNode = findState(nodes: nodes, state: "end")[0]
    
    // getting the A-Star path
    let path:[HNode] = RunAStar(nodes: nodes, startNode: startNode, endNode: endNode)
    
    var body: some View {
        VStack(alignment: .center, spacing: 0.0) {
            // processing row by row in VStack
            ForEach(nodes, id: \.self) { row in
                HStack(alignment: .center, spacing: 0.0) {
                    // rendering each node in the row in HStack
                    ForEach(row, id: \.nodeNum) { node in
                        RenderNode(node: node, path: path)
                    }
                }
            }
        }
    }
    return body
}

// given a node and a list of neighbros (not of that node), returns true if this node happens to be in the list of neighbors
func RenderNode(node:HNode, path:[HNode]) -> some View {
    if path.contains(node) {
        node.state.name = "path"
    } else {
        node.state.name = "untouched"
    }
    
    return node
}

func findState(nodes:[[HNode]], state:String) -> [HNode] {
    var result:[HNode] = []
    
    for row in nodes {
        for node in row {
            if node.state.name == state {
                result.append(node)
            } else { continue }
        }
    }
    
    return result
}


// creates square grid as [[HNode]] with numOfNodes side length
func buildNodes(numOfNodes:Int) -> [[HNode]] {
    var nodes:[[HNode]] = []
    
    // creates square grid with numOfNodes side length
    for y in 0...(numOfNodes-1) {
        
        // holds a row
        var row:[HNode] = []
        
        // adds nodes to the row
        for x in 0...(numOfNodes-1) {
            row.append(HNode(posn: (x,y), numberOfNodes: numOfNodes))
        }
        
        // adds row to nodes
        nodes.append(row)
    }
    
    return nodes
}




// defines the screen dimensions
extension UIScreen{
   static let screenWidth = UIScreen.main.bounds.size.width
   static let screenHeight = UIScreen.main.bounds.size.height
   static let screenSize = UIScreen.main.bounds.size
}

struct Previews_RenderFile_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
