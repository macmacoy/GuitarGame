//
//  ChordSCNNodeFactory.swift
//  GuitarGame
//
//  Created by Mac Macoy on 11/6/18.
//  Copyright © 2018 Mac Macoy. All rights reserved.
//

import Foundation
import SceneKit

class ChordSCNNodeFactory {
    
    private var scene: SCNScene!
    private let colors = Colors()
    private let viewConstants = ViewConstants()
    private var numMade = 0
    
    init() {
        self.scene = SCNScene(named: "art.scnassets/Chord.scn")
    }
    
    func make(chordName: String, zLength: Double, zStart: Double, zEnd: Double) -> SCNNode {
        let chordSCNNode = deepCopy(boilerplate: self.scene.rootNode.childNode(withName: "Chord", recursively: true)!)
        chordSCNNode.name = "Chord" + String(numMade)
        setLength(zLength: zLength, chordSCNNode: chordSCNNode)
        setPosition(zStart: zStart, zEnd: zEnd, chordSCNNode: chordSCNNode)
        addChordString(chordName: chordName, chordSCNNode: chordSCNNode)
        setChordColor(chordName: chordName, chordSCNNode: chordSCNNode)
        numMade += 1
        return chordSCNNode
    }
    
    private func deepCopy(boilerplate: SCNNode) -> SCNNode {
        let scnNode = boilerplate.clone()
        scnNode.geometry = boilerplate.geometry?.copy() as? SCNGeometry
        if let newMaterial = scnNode.geometry?.materials.first?.copy() as? SCNMaterial {
            //make changes to material
            scnNode.geometry?.materials = [newMaterial]
        }
        for child in scnNode.childNodes {
            scnNode.replaceChildNode(child, with: deepCopy(boilerplate: child))
        }
        return scnNode
    }
    
    private func setLength(zLength: Double, chordSCNNode: SCNNode) {
        (chordSCNNode.geometry as! SCNBox).length = CGFloat(zLength - viewConstants.spaceBetweenChords)
    }
    
    private func setPosition(zStart: Double, zEnd: Double, chordSCNNode: SCNNode) {
        let newPosition = SCNVector3(0, 0, zStart + Double((chordSCNNode.geometry as! SCNBox).length/2) - viewConstants.spaceBetweenChords/2)
        chordSCNNode.position = newPosition
    }
    
    private func addChordString(chordName: String, chordSCNNode: SCNNode) {
        let chordNameSCNNode = chordSCNNode.childNode(withName: "Chord Name", recursively: true)!
        (chordNameSCNNode.geometry as! SCNText).string = chordName
        setChordNamePosition(chordSCNNode: chordSCNNode, chordNameSCNNode: chordNameSCNNode)
        chordNameSCNNode.geometry?.firstMaterial?.diffuse.contents = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    private func setChordNamePosition(chordSCNNode: SCNNode, chordNameSCNNode: SCNNode) {
        // bring to front of chord view
        let newChordNameSCNNodeZPosition = chordNameSCNNode.position.z - Float((chordSCNNode.geometry as! SCNBox).length/2) + Float(viewConstants.spaceBetweenChordNameAndEdge)
        chordNameSCNNode.position.z = newChordNameSCNNodeZPosition
        
        // center the text
        let max = chordNameSCNNode.boundingBox.max
        let min = chordNameSCNNode.boundingBox.min
        chordNameSCNNode.pivot = SCNMatrix4MakeTranslation((max.x - min.x) / 2, 0, 0);
    }
    
    private func setChordColor(chordName: String, chordSCNNode: SCNNode) {
        chordSCNNode.geometry?.firstMaterial?.diffuse.contents = colors.chordNotHit
    }
    
    var defaultChordSCNNodeLength: Double {
        let chordSCNNode = self.scene.rootNode.childNode(withName: "Chord", recursively: true)!.clone()
        return Double((chordSCNNode.geometry as! SCNBox).length)
    }
    
}
