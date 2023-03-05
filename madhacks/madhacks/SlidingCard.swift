//
//  SlidingCard.swift
//  madhacks
//
//  Created by Stephanie Ran on 3/4/23.
//

import UIKit
import CardSlider


class SlidingCard: UIViewController {
    var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        button = UIButton(frame: CGRect(x: 200, y: 100, width: 100, height: 50))
        button.backgroundColor = .green
        button.setTitle("Test Button", for: .normal)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)

        self.view.addSubview(button)
        
        
    }
    
    @objc func buttonAction(sender: UIButton!) {
      print("Button tapped")
    }
    
//    @IBAction func didTapButton() {
//        // Present the card slider
//
//        let vc = CardSliderViewController.with(dataSource: self)
//        vc.modalPresentationStyle = .fullScreen
//        vc.title = "Welcome!"
//        present(vc, animated: true)
//    }

}
