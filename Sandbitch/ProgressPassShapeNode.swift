//
//  ProgressPassShapeNode.swift
//  Sandbitch
//
//  Created by 佐藤周平 on 2019/06/30.
//  Copyright © 2019 佐藤周平. All rights reserved.
//

import SpriteKit
import GameplayKit

// パスを用いてプログレスを表現する ShapeNode
// Shader にアトリビュートが渡らないため、uniform を使う
// SpriteKit のバグ?
// https://stackoverflow.com/questions/50885130/spritekit-issue-with-skshader-animation-in-swift
class ProgressPassShapeNode : SKShapeNode {
    static let shader : SKShader = {
        let shader = SKShader(fileNamed: "ProgressPassShader.fsh")
        /*
        shader.attributes = [
            SKAttribute(name: "u_progress", type: .float)
        ]
        */
        shader.uniforms = [
            SKUniform(name: "u_progress", float: 0.0)
        ]
        return shader
    }()
    var progress : Float = 0.0 {
        willSet {
            //self.setValue(SKAttributeValue(float: newValue), forAttribute: "a_progress")
            self.strokeShader?.uniformNamed("u_progress")?.floatValue = newValue
        }
    }
    
    func setupShader() {
        self.strokeShader = ProgressPassShapeNode.shader
    }
    override init() {
        super.init()
        setupShader()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupShader()
    }
}
