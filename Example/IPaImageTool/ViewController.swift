//
//  ViewController.swift
//  IPaImageTool
//
//  Created by ipapamagic@gmail.com on 09/16/2017.
//  Copyright (c) 2017 ipapamagic@gmail.com. All rights reserved.
//

import UIKit
import IPaImageTool
class ViewController: UIViewController {
    lazy var originalImage:UIImage = UIImage(named: "1.JPG")!.rotationFixImage!
    var angle:Float = 0
    @IBOutlet weak var contentImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

//    @IBAction func onRotateImage45(_ sender: Any) {
//
//        angle += 45
//        let transform = CGAffineTransform(rotationAngle: CGFloat(angle * Float.pi / 180.0) )
//
////        let newImage = originalImage.image(apply:transform)!
//        let newImage = originalImage.image(contextCTM:transform,rect:CGRect(x:0, y: 0, width: 100, height: 100))
////        print(newImage)
//        contentImageView.image = newImage
//
//    }
}

