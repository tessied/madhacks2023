//
//  ViewController.swift
//  madhacks
//
//  Created by Stephanie Ran on 3/4/23.
//

import UIKit
import CardSlider

struct Item: CardSliderItem {
    var image: UIImage
    var rating: Int?
    var title: String
    var subtitle: String?
    var description: String?
}


class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CardSliderDataSource {
    
    var cardData = [Item]()
    
    
    @IBOutlet weak var table: UITableView!
    //@IBOutlet weak var imageView: UIImageView
    @IBOutlet weak var button: UIButton!
    
    let searchController = UISearchController()
    
    var filteredPhotos = [FamPhoto]()
    
    // family photo struct
    struct FamPhoto {
        let title: String
        let imageName: String
    }
    
    // array of photos
    let data: [FamPhoto] = [
        FamPhoto(title: "fam1", imageName: "photo1"),
        FamPhoto(title: "fam2", imageName: "photo2")
    ]
    
    var filteredData: [FamPhoto]!
    
    override func viewDidLoad() {
        
        /* Card Slider*/
        super.viewDidLoad()
        cardData.append(Item(image: UIImage(named: "bobo")!,
                         rating: nil,
                         title: "Steph",
                         subtitle: "Baby bobo having a good time",
                         description: nil))
        
        cardData.append(Item(image: UIImage(named: "siroo")!,
                         rating: nil,
                         title: "Jack",
                         subtitle: "Siroo turned 1 yesterday!!!",
                         description: nil))
        
        cardData.append(Item(image: UIImage(named: "husko")!,
                         rating: nil,
                         title: "Tessie",
                         subtitle: "he so handsome",
                         description: nil))
        
//            myButton.backgroundColor = .link
//        myButton.setTitleColor(.white, for: .normal)
        
        
        // Do any additional setup after loading the view.
        title = "placeholder"
        self.filteredPhotos = data
        
        button.tintColor = UIColor(red: 157/255, green: 129/255, blue: 137/255, alpha: 1.0)
        
        
        table.dataSource = self
        table.delegate = self
    }
    
    /* Camera Function */
    @IBAction func didTapButton() {
        
    }
    
    
    /* Table Formatting */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let photo = data[indexPath.row]
        let cell = table.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
        cell.label.text = photo.title
        cell.iconImageView.layer.masksToBounds = true
        cell.iconImageView.layer.cornerRadius = 50 // change later for circle
        cell.iconImageView.image = UIImage(named: photo.imageName)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = CardSliderViewController.with(dataSource: self)
        vc.modalPresentationStyle = .fullScreen
        vc.title = "Welcome!"
        present(vc, animated: true)
        //dismiss(animated: true, completion: nil)
    }
    
    func item(for index: Int) -> CardSlider.CardSliderItem {
        return cardData[index]
    }
    
    func numberOfItems() -> Int {
        return cardData.count
    }

}
