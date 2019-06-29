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
        let gal_a = self.childNode(withName: "gal_a") as! SKSpriteNode
        let gal_b = self.childNode(withName: "gal_b") as! SKSpriteNode
        let gal_c = self.childNode(withName: "gal_c") as! SKSpriteNode
        let gal_a_num = self.childNode(withName: "//gal_a_num") as! SKLabelNode
        let gal_b_num = self.childNode(withName: "//gal_b_num") as! SKLabelNode
        let gal_c_num = self.childNode(withName: "//gal_c_num") as! SKLabelNode
        let gal_a_score = self.childNode(withName: "//gal_a_score") as! SKLabelNode
        let gal_b_score = self.childNode(withName: "//gal_b_score") as! SKLabelNode
        let gal_c_score = self.childNode(withName: "//gal_c_score") as! SKLabelNode
        let total_score = self.childNode(withName: "//total_score") as! SKLabelNode
        let return_btn = self.childNode(withName: "return") as! SKSpriteNode
        
        gal_a_num.text = "\(result!.gal_a_num)"
        gal_b_num.text = "\(result!.gal_b_num)"
        gal_c_num.text = "\(result!.gal_c_num)"
        gal_a_score.text = "\(result!.gal_a_score)"
        gal_b_score.text = "\(result!.gal_b_score)"
        gal_c_score.text = "\(result!.gal_c_score)"
        total_score.text = "\(result!.score)"
      
        gal_a.alpha = 0
        gal_b.alpha = 0
        gal_c.alpha = 0
        gal_a_num.alpha = 0
        gal_b_num.alpha = 0
        gal_c_num.alpha = 0
        gal_a_score.alpha = 0
        gal_b_score.alpha = 0
        gal_c_score.alpha = 0
        total_score.alpha = 0
        return_btn.alpha = 0
      
        gal_a.position.y -= 160
        gal_b.position.y -= 160
        gal_c.position.y -= 160
        gal_a_num.position.y -= 160
        gal_b_num.position.y -= 160
        gal_c_num.position.y -= 160
        gal_a_score.position.y -= 160
        gal_b_score.position.y -= 160
        gal_c_score.position.y -= 160

        let score_act = SKAction.sequence([SKAction.group([SKAction.moveBy(x:0, y:+160, duration: 0.5),
                                                           SKAction.fadeIn(withDuration: 0.5)]),
                                           SKAction.wait(forDuration: 0.2)])
        gal_a.run(score_act) {
            gal_b.run(score_act) {
                gal_c.run(score_act)
            }
        }
        gal_a_num.run(score_act) {
            gal_b_num.run(score_act) {
                gal_c_num.run(score_act)
            }
        }
        gal_a_score.run(score_act) {
            gal_b_score.run(score_act) {
                gal_c_score.run(score_act) {
                    total_score.run(SKAction.sequence([SKAction.group([SKAction.fadeAlpha(to: 0.8, duration: 1),
                                                                       SKAction.scale(by: 0.8, duration: 1)]),
                                                       SKAction.group([SKAction.scale(by: 1.2, duration: 0.1),
                                                                       SKAction.fadeAlpha(to: 1, duration: 0.1)]),
                                                       SKAction.scale(by: 0.8, duration: 0.1)])) {
                                                        return_btn.run(SKAction.fadeIn(withDuration: 0.5))
                    }
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 戻るボタンが押されたらタイトルへ
        for t in touches {
            let loc = t.location(in: self)
            let node = self.atPoint(loc)
            if node.name == "return" {
                if let view = self.view {
                    if let scene = SKScene(fileNamed: "TitleScene") {
                        scene.scaleMode = .aspectFill
                        view.presentScene(scene)
                        return
                    }
                }
            }
        }
    }

}
