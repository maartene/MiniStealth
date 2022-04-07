//
//  SKonsole.swift
//  MiniStealth
//
//  Created by Maarten Engels on 03/02/2022.
//

import Foundation
import SpriteKit

final class SKonsole: SKNode {
    
    let rowCount: Int
    let colCount: Int
    
    private let characterTranslationTable: [Character: String] = [
           "A": "aa",
           "B": "bb",
           "C": "cc",
           "D": "dd",
           "E": "ee",
           "F": "ff",
           "G": "gg",
           "H": "hh",
           "I": "ii",
           "J": "jj",
           "K": "kk",
           "L": "ll",
           "M": "mm",
           "N": "nn",
           "O": "oo",
           "P": "pp",
           "Q": "qq",
           "R": "rr",
           "S": "ss",
           "T": "tt",
           "U": "uu",
           "V": "vv",
           "W": "ww",
           "X": "xx",
           "Y": "yy",
           "Z": "zz",
           
           ",": "comma",
           "!": "exclamationMark",
           " ": "space",
           ".": "period",
           ":": "collon",
           ")": "closeBrackets",
           "(": "openBrackets",
           "?": "questionMark",
           "@": "at",
           "'": "singleQuote",
           "-": "hyphen",
           "_": "underscore",
           "=": "equals"
       ]
    
    private var fgNodes = [SKSpriteNode]()
    private var bgNodes = [SKSpriteNode]()
    private var textureCache = [String: SKTexture]()
    
    init(colCount: Int, rowCount: Int) {
        self.rowCount = rowCount
        self.colCount = colCount
        
        super.init()
        
        let texture = SKTexture(imageNamed: "square_16x16")
        texture.filteringMode = .nearest
        
        // NOTE: it is not necesarry per se to perform the coloring step or assigning a texture.
        // Just make sure that:
        // 1. An SKSpriteNode instance is added for every cell to the bgNodes and fgNodes arrays
        // 2. The size of the node is set to 16x16 (assigning the texture we loaded above does this automatically)
        for y in 0 ..< rowCount {
            for x in 0 ..< colCount {
                let fgNode = SKSpriteNode(texture: texture)
                fgNode.position = CGPoint(x: 8 + 16 * x, y: 8 + 16 * y)
                fgNode.colorBlendFactor = 1.0
                fgNode.color = SKColor(calibratedHue: CGFloat.random(in: 0 ... 1.0), saturation: 1, brightness: 1, alpha: 1)
                
                addChild(fgNode)
                fgNodes.append(fgNode)
                
                let bgNode = SKSpriteNode(texture: texture)
                bgNode.position = CGPoint(x: 8 + 16 * x, y: 8 + 16 * y)
                bgNode.colorBlendFactor = 1.0
                bgNode.color = SKColor(calibratedHue: CGFloat.random(in: 0 ... 1.0), saturation: 1, brightness: 1, alpha: 1)
                bgNode.zPosition = -1   // this forces the node to be drawn further in the back. value doesn't matter as long as bgNode.zPosition < fgNode.zPosition
                
                addChild(bgNode)
                bgNodes.append(bgNode)
            }
        }
    }
    
    func putForeground(_ textureName: String, at position: Vector, color: SKColor = .white) {
        let node = fgNodes[position.y * colCount + position.x]
        node.texture = getTextureFromCache(textureName)
        node.color = color
        node.isHidden = false
    }
    
    func putBackground(_ textureName: String, at position: Vector, color: SKColor = .darkGray) {
        let node = bgNodes[position.y * colCount + position.x]
        node.texture = getTextureFromCache(textureName)
        node.color = color
        node.isHidden = false
    }
    
    func putChar(_ character: Character, at position: Vector, fgColor: SKColor = .white, bgColor: SKColor? = nil, alignment: Alignment = .left) {
        let textureName = characterTranslationTable[character] ?? String(character)
        
        putForeground(textureName, at: position, color: fgColor)
        
        if let bgColor = bgColor {
            putBackground("square_16x16", at: position, color: bgColor)
        }
    }
    
    func putString(_ string: String, at position: Vector, fgColor: SKColor = .white, bgColor: SKColor? = nil, alignment: Alignment = .left) {
        var cursor = position
        
        if alignment == .center {
            cursor.x = colCount / 2 - string.count / 2
        }
        
        for character in string {
            putChar(character, at: cursor, fgColor: fgColor, bgColor: bgColor)
            cursor.x += 1
        }
    }
    
    func clear() {
        for node in fgNodes {
            node.texture = nil
            node.isHidden = true
        }
        
        for node in bgNodes {
            node.texture = nil
            node.isHidden = true
        }
    }
    
    private func getTextureFromCache(_ textureName: String) -> SKTexture {
        if let texture = textureCache[textureName] {
            return texture
        } else {
            let texture = SKTexture(imageNamed: textureName)
            texture.filteringMode = .nearest
            textureCache[textureName] = texture
            return texture
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    enum Alignment {
        case left
        case center
    }
}
