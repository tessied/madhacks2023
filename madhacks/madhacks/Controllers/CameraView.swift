//
//  CameraView.swift
//  madhacks
//
//  Created by Stephanie Ran on 3/4/23.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage

class CameraView: UIViewController {
    
    var img: UIImage!
    var caption: String!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var button: UIButton!
    @IBOutlet var btn: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        imageView.image = img
        
    }
    
    func updateImg(image: UIImage) {
        self.img = image
    }
    
    
}


