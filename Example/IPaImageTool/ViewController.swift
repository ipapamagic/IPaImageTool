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

    @IBAction func onRotateImage45(_ sender: Any) {
        
        angle += 45
        let transform = CGAffineTransform(rotationAngle: CGFloat(angle * Float.pi / 180.0) )
        
        let newImage = originalImage.image(apply:transform)!
//        print(newImage)
        contentImageView.image = newImage
//        let data = UIImageJPEGRepresentation(newImage, 1)
//        
//        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
//        let url = URL(fileURLWithPath: (path as NSString).appendingPathComponent("1.jpg"))
//        do {
//            try data?.write(to: url)
//        }
//        catch {
//            
//        }
    }
}

