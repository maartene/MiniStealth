//
//  SKonsole.swift
//  MiniStealth
//
//  Created by Maarten Engels on 21/01/2022.
//

import Foundation
import SpriteKit

final class SKonsole: SKNode {
    
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
    
    let rowCount: Int
    let colCount: Int
    
    private var fgNodes = [SKSpriteNode]()
    
    private var textureCache = [String: SKTexture]()
    
    init(colCount: Int, rowCount: Int) {
        self.colCount = colCount
        self.rowCount = rowCount
        
        super.init()
        
        let texture = SKTexture(imageNamed: "square_16x16")
        texture.filteringMode = .nearest
        
        for y in 0 ..< rowCount {
            for x in 0 ..< colCount {
                let fgNode = SKSpriteNode(texture: texture)
                fgNode.position = CGPoint(x: 8 + 16 * x, y: 8 + 16 * y)
                fgNode.colorBlendFactor = 1.0
                fgNode.color = SKColor(calibratedHue: CGFloat.random(in: 0 ... 1.0), saturation: 1, brightness: 1, alpha: 1)
                
                addChild(fgNode)
                fgNodes.append(fgNode)
            }
        }
        
    }
    
    func putChar(_ character: Character, at position: Vector, fgColor: SKColor = .white) {
        let node = fgNodes[position.y * colCount + position.x]
        
        let textureName = characterTranslationTable[character] ?? String(character)
        
        if let texture = textureCache[textureName] {
            node.texture = texture
        } else {
            let texture = SKTexture(imageNamed: textureName)
            texture.filteringMode = .nearest
            node.texture = texture
            textureCache[textureName] = texture
        }
        
        node.color = fgColor
    }
    
    func putString(_ string: String, at position: Vector, fgColor: SKColor = .white) {
        var cursor = position
        for character in string {
            putChar(character, at: cursor, fgColor: fgColor)
            cursor.x += 1
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

struct Vector {
    var x: Int
    var y: Int
}
