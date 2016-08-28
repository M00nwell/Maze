//
//  MainVC.swift
//  Maze
//
//  Created by Wenzhe on 8/5/16.
//  Copyright © 2016 Wenzhe. All rights reserved.
//

import UIKit

class MainVC: UIViewController, iCarouselDelegate, iCarouselDataSource {
    @IBOutlet var carouselView: iCarousel!
    var stages = [Int]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        stages = [0,1,2,3,4,5,6,7,8,9,10,11,12,13]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        carouselView.delegate = self
        carouselView.dataSource = self
        carouselView.type = .CoverFlow
    }
    
    func numberOfItemsInCarousel(carousel: iCarousel) -> Int {
        return stages.count
    }
    
    func carousel(carousel: iCarousel, viewForItemAtIndex index: Int, reusingView view: UIView?) -> UIView {
        let tempView = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        tempView.backgroundColor = UIColor(hex: 0x17291D, alpha: 1)
        let button = UIButton(frame: CGRect(x: 10, y: 10, width: 280, height: 280))
        button.backgroundColor = UIColor(hex: 0x8CFFB3, alpha: 1)
        button.setTitle("STAGE\(index)", forState: .Normal)
        button.titleLabel!.font = UIFont(name: "DINCondensed-Bold", size: 45)
        button.setTitleColor(UIColor(hex: 0x17291D, alpha: 1), forState: .Normal)
        button.tag = index
        button.addTarget(self, action: #selector(self.enterGame(_:)), forControlEvents: .TouchUpInside)
        tempView.addSubview(button)
        
        return tempView
    }
    
    func carousel(carousel: iCarousel, valueForOption option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if option == iCarouselOption.Spacing{
            return value
        }
        return value
    }
    
    func enterGame(sender: UIButton){
        let gameVC = storyboard?.instantiateViewControllerWithIdentifier("gameVC") as! GameViewController
        gameVC.stage = sender.tag
        presentViewController(gameVC, animated: true, completion: nil)
    }

}

extension UIColor {
    
    convenience init(hex: UInt32, alpha: CGFloat) {
        let red = CGFloat((hex & 0xFF0000) >> 16)/256.0
        let green = CGFloat((hex & 0xFF00) >> 8)/256.0
        let blue = CGFloat(hex & 0xFF)/256.0
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
