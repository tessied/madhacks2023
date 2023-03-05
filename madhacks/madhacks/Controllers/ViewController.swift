//
//  ViewController.swift
//  madhacks
//
//  Created by Stephanie Ran on 3/4/23.
//

import UIKit
import CardSlider
import FirebaseDatabase
import FirebaseStorage

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
        FamPhoto(title: "kimmys", imageName: "fam"),
        FamPhoto(title: "Big Ran", imageName: "stephFam"),
        FamPhoto(title: "soh soh", imageName: "jamesFam"),
        FamPhoto(title: "KTP Fam", imageName: "ktp")
    ]
    
    var filteredData: [FamPhoto]!
    
    override func viewDidLoad() {
        
        /* Card Slider*/
        super.viewDidLoad()
        let ref = Database.database().reference()
    
        
        ref.child("uploads").observe(.childAdded) { snapshot, secondarg   in
            let upload = Upload.fromDictionary(snapshot.value as! [String: Any])
            let storageRef = Storage.storage().reference(withPath: upload?.photo ?? "")
            
            storageRef.getData(maxSize: 1000 * 1024 * 1024) { data, error in
              if let error = error {
                // Uh-oh, an error occurred!
                print("Error downloading image: \(error)")
              } else {
                // Data for "path/to/image.jpg" is returned
                let image_ = UIImage(data: data!)
                  
                  let rotatedImage: UIImage = UIImage(cgImage: (image_?.cgImage)!, scale: image_!.scale, orientation: .right)

                // Do something with the image, such as displaying it in an UIImageView
                // imageView.image = image
                  self.cardData.append(Item(image: rotatedImage,
                                   rating: nil,
                                   title: "James",
                                   subtitle: "Baby bobo having a good time",
                                   description: nil))
                  
                  print("Done Getting Photos")
              }
            }
            
        }
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

        
        
        // Do any additional setup after loading the view.
        title = "tree."
        self.filteredPhotos = data
        
        button.tintColor = UIColor(red: 157/255, green: 129/255, blue: 137/255, alpha: 1.0) //198, 236, 213
        
        
        table.dataSource = self
        table.delegate = self
        
    }
    
    /* Camera Function */
    @IBAction func didTapButton() {
        let picker = UIImagePickerController()
        
        picker.sourceType = .camera
        //picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    
    /* Table Formatting */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let photo = data[indexPath.row]
        let cell = table.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
        cell.label.text = photo.title
        //cell.iconImageView.layer.masksToBounds = true
        //cell.iconImageView.layer.cornerRadius = 100 // change later for circle
        cell.iconImageView.image = UIImage(named: photo.imageName)
        cell.iconImageView.round()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = CardSliderViewController.with(dataSource: self)
        vc.modalPresentationStyle = .fullScreen
        vc.isModalInPresentation = false
        vc.title = "Prompt: We love our furry friends. Send a picture of your pet!"
        present(vc, animated: true, completion: nil)
        //dismiss(animated: true, completion: nil)
    }
    
    func item(for index: Int) -> CardSlider.CardSliderItem {
        return cardData[index]
    }
    
    func numberOfItems() -> Int {
        return cardData.count
    }

}

/* Camera Stuff*/
extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        
        guard let image1 = info[UIImagePickerController.InfoKey.originalImage] as?
        UIImage else{
            return
        }
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Camera") as? CameraView {
            vc.img = image1
            navigationController?.pushViewController(vc, animated: true)
        }
        
        //CameraView.updateImg(image1)
        //CameraView.updateImg(CameraView, image1)
    }
}

public extension UIView {
    func round() {
        let width = bounds.width < bounds.height ? bounds.width : bounds.height
        let mask = CAShapeLayer()
        mask.path = UIBezierPath(ovalIn: CGRectMake(bounds.midX - width / 2, bounds.midY - width / 2, width, width)).cgPath
        self.layer.mask = mask
    }
}
