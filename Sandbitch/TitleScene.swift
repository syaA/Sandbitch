//
//  TitleScene.swift
//  Sandbitch
//
//  Created by 佐藤周平 on 2019/06/22.
//  Copyright © 2019 佐藤周平. All rights reserved.
//

import SpriteKit
import GameplayKit

class TitleScene: SKScene {
    
    var tapToStart : SKSpriteNode?
    override func didMove(to view: SKView) {
        
        self.tapToStart = self.childNode(withName: "//taptostart") as? SKSpriteNode
        if let s = self.tapToStart {
            s.run(SKAction.repeatForever(SKAction.init(named: "Blink")!));
       }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let view = self.view {
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
            }
        }
    }
}
