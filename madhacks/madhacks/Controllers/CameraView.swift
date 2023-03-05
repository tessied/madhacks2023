//
//  CameraView.swift
//  madhacks
//
//  Created by Stephanie Ran on 3/4/23.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage

class CameraView: UIViewController, UITextFieldDelegate {
    
    var img: UIImage!
    var caption: String!
    @IBOutlet weak var captionTextField: UITextField!
    @IBOutlet var imageView: UIImageView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        imageView.image = img
        
    }
    
}


