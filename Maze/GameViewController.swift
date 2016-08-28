//
//  GameViewController.swift
//  Maze
//
//  Created by Wenzhe on 25/3/16.
//  Copyright (c) 2016 Wenzhe. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    
    var stage: Int?
    var gameScene:GameScene?

    override func viewDidLoad() {
        super.viewDidLoad()

        showGameScene()
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    @IBAction func menuPressed(sender: UIButton) {
        self.gameScene?.removeAllActions()
        self.gameScene?.removeAllChildren()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func gameEnd(){
        let alert = UIAlertController(title: "YOU WIN!", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
            alert.dismissViewControllerAnimated(true, completion: nil)
            self.gameScene?.removeAllActions()
            self.gameScene?.removeAllChildren()
            self.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func youDie(){
        let alert = UIAlertController(title: "YOU DIED!", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "MENU", style: .Default, handler: { (action: UIAlertAction!) in
            alert.dismissViewControllerAnimated(true, completion: nil)
            self.gameScene?.removeAllActions()
            self.gameScene?.removeAllChildren()
            self.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "RETRY", style: .Default, handler: { (action: UIAlertAction!) in
            alert.dismissViewControllerAnimated(true, completion: nil)
            self.gameScene?.removeAllActions()
            self.gameScene?.removeAllChildren()
            self.showGameScene()
        }))
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func showGameScene(){
        let fileName = "stage\(stage!)"
        if let gameScene = GameScene(fileNamed:fileName) {
            // Configure the view.
            let skView = self.view as! SKView
            //skView.showsFPS = true
            //skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            gameScene.scaleMode = .AspectFill
            
            gameScene.gameVC = self
            gameScene.stage = self.stage
            skView.presentScene(gameScene)
            self.gameScene = gameScene
        }
    }
}
