//
//  ResultScene.swift
//  Sandbitch
//
//  Created by 佐藤周平 on 2019/06/27.
//  Copyright © 2019 佐藤周平. All rights reserved.
//

import SpriteKit
import GameplayKit

class ResultScene: SKScene {
    
    var result : ResultInfo?
    
    override func didMove(to view: SKView) {
        (self.childNode(withName: "//gal_a_num") as! SKLabelNode).text = "\(result!.gal_a_num)"
        (self.childNode(withName: "//gal_b_num") as! SKLabelNode).text = "\(result!.gal_b_num)"
        (self.childNode(withName: "//gal_c_num") as! SKLabelNode).text = "\(result!.gal_c_num)"
        (self.childNode(withName: "//gal_a_score") as! SKLabelNode).text = "\(result!.gal_a_score)"
        (self.childNode(withName: "//gal_b_score") as! SKLabelNode).text = "\(result!.gal_b_score)"
        (self.childNode(withName: "//gal_c_score") as! SKLabelNode).text = "\(result!.gal_c_score)"
        (self.childNode(withName: "//total_score") as! SKLabelNode).text = "\(result!.score)"
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let view = self.view {
            if let scene = SKScene(fileNamed: "TitleScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
            }
        }
    }
}
