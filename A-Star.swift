//
//  A-Star.swift
//  Test project
//
//  Created by Hassan Jamil on 2021-12-24.
//

import Foundation
import SwiftUI


// function that runs the a-star algorithm on a grid of HNode's
func RunAStar(nodes:[[HNode]], startNode:HNode, endNode:HNode) -> [HNode] {
    // the open nodes are a union between neighbors of current node and existing open nodes
    var openNodes:[HNode] = []
    var closedNodes:[HNode] = []
    
    var currentNode:HNode = startNode
    var neighbors:[HNode]
    var minNode:HNode
    
    var pathToEnd:[HNode] = [startNode]
    var potentialPathNodes:[HNode] = []
    currentNode.precedingNode = startNode.posn
    currentNode = currentNode.CalculateCosts(endNode: endNode, parentNode: currentNode)
    
    // runs algo to find a path to end node, outputs the end node modified with a chain of nodes behind it (the path)
    while currentNode.state.name != "end" {
        // adding the node about to evaluate to the list of closed nodes
        closedNodes.append(currentNode)
        
        // gets all the neighbors of current node and calculates the cost
        neighbors = getNeighbors(grid: nodes, currentNode: currentNode, endNode: endNode, closed: closedNodes)
        
        //creates new list of all the open nodes, along with calculating the minimum costs of each node
        openNodes = HNodeUnion(l1: openNodes, l2: neighbors, closed: closedNodes)
        
        // get the node in openNodes with the lowest cost
        minNode = minCost(openNodes: openNodes)
        
        // set the currentNode equal to the now lowest cost node
        currentNode = minNode
        
        potentialPathNodes.append(currentNode)
    }
    
    //now that end node is found, recreate the path taken to get to that node
    while currentNode.state.name != "start" {
        pathToEnd.append(currentNode)
        currentNode = nodes[currentNode.precedingNode.1][currentNode.precedingNode.0]
        
        currentNode = find(node: currentNode, nodes: closedNodes)!
    }
    
    
    return pathToEnd
    
}


// returns euclidean distance between two integer tuples as a Double
func tupleDist(t1:(Int,Int), t2:(Int,Int)) -> Double {
    return sqrt(pow(Double(t1.0 - t2.0), 2.0) + pow(Double(t1.1 - t2.1), 2.0))
}


// given the currentNode:HNode, startNode:Hnode (origin node), endNode:Node (goal node), and allNodes:[[Hnode]], which represents the grid of all nodes, returns the node with the lowest FCost. if FCost of multple nodes are same, then returns node with the lower HCost
// assume that all nodes in openNodes already have their minimized FCost
func minCost(openNodes:[HNode]) -> HNode {
    var minNode:HNode = openNodes[0]
    
    for node in openNodes {
        if (node.FCost < minNode.FCost) ||
            ((node.FCost == minNode.FCost) && (node.HCost < minNode.HCost)) {
            minNode = node
        }
        else {
            continue
        }
    }
    
    return minNode
}

// given the grid:[[Hnode]], and currentNode:HNode, returns a listof all the nodes neighboring currentNode, [HNode]
func getNeighbors(grid:[[HNode]], currentNode:HNode, endNode:HNode, closed:[HNode]) -> [HNode] {
    
    var neighbors:[HNode] = []
    let posn:(Int,Int) = currentNode.posn
    
    for x in -1...1 {
        for y in -1...1 {
            if // checking if node is within the grid
                (posn.0 + x > grid.count-1) ||
                (posn.0 + x < 0) ||
                (posn.1 + y > grid.count-1) ||
                    (posn.1 + y < 0) ||
                // checking if the node is a barrier
                    (grid[posn.1 + y][posn.0 + x].state.name == "barrier") ||
                // checking if the node is closed
                    (closed.contains(grid[posn.1 + y][posn.0 + x])) ||
                // if the node is actually the current node (node cant be its own neighbor!)
                ((posn.0 + x, posn.1 + y) == currentNode.posn)
            {
                continue
            }
            else {
                // setting up the varibles for cost and preceeding node
                var node:HNode = grid[posn.1 + y][posn.0 + x]
                
                node.precedingNode = currentNode.posn
                node = node.CalculateCosts(endNode: endNode, parentNode: currentNode)
                
                // else, is a valid nehgbor node.
                neighbors.append(node)
            }
        }
    }
    
    return neighbors
}


// given two HNode lists, returns the union between those elements (favours l1 items)
// to be used by doing a union between the existing open nodes nad hte neighbors of currentNode
// also filters out any elements from both lists inside closed:[HNode]
func HNodeUnion(l1:[HNode], l2:[HNode], closed:[HNode]) -> [HNode] {
    
    let l1Filt:[HNode] = l1.filter { !closed.contains($0) }
    let l2Filt:[HNode] = l2.filter { !closed.contains($0) }
    
    var result:[HNode] = l2Filt
    
    for el in l1Filt {
        let node:HNode? = find(node: el, nodes: result)

        // if node is common between both lists, put the copy of the node that has the lower FCost
        if node != nil {
            if el.FCost < node!.FCost {
                result.append(el)
            } else {
                continue
            }
        }
        else {
            result.append(el)
        }
    }
    
    return result
}

func find(node:HNode, nodes:[HNode]) -> HNode? {
    if nodes == [] {
        return nil
    }
    
    for el in nodes {
        if node.posn == el.posn {
            return el
        }
    }
    return nil
}
