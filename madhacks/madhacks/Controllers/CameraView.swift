//
//  CameraView.swift
//  madhacks
//
//  Created by Stephanie Ran on 3/4/23.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage

class User {
    var name: String?
    var topFan: String?
    
    init(name: String?, topFan: String?) {
            self.name = name
            self.topFan = topFan
        }
    
    func toDictionary() -> [String:Any] {
        return [
            "name": name ?? "",
            "topFan": topFan ?? ""
        ]
    }
    
    static func fromDictionary(_ dict: [String: Any]) -> User? {
            guard let name = dict["name"] as? String,
                  let topFan = dict["topFan"] as? String
        else {
                return nil
            }
            
            return User(name: name, topFan: topFan)
        }
}

class Upload {
    var uploadID: String?
    var groupID: String?
    var creatorID: String?
    var date: Date?
    var caption: String?
    var photo: String?
    
    init(uploadID: String?, groupID: String?, creatorID: String?, date: Date?, caption: String?, photo: String?) {
            self.uploadID = uploadID
            self.groupID = groupID
            self.creatorID = creatorID
            self.date = date
            self.caption = caption
            self.photo = photo
        }
    
    func toDictionary() -> [String:Any] {
        return [
            "uploadID": uploadID ?? "",
            "groupID": groupID ?? "",
            "creatorID": creatorID ?? "",
            "date": date?.timeIntervalSince1970 ?? 0,
            "caption": caption ?? "",
            "photo": photo ?? ""
        ]
    }
    
    static func fromDictionary(_ dict: [String: Any]) -> Upload? {
            guard let uploadID = dict["uploadID"] as? String,
                  let groupID = dict["groupID"] as? String,
                  let creatorID = dict["creatorID"] as? String,
                  let date: Date? = Date.init(timeIntervalSince1970: dict["date"] as! TimeInterval),
                  let caption = dict["caption"] as? String,
                  let photo = dict["photo"] as? String
        else {
                return nil
            }

            return Upload(uploadID: uploadID, groupID: groupID, creatorID: creatorID, date: date, caption: caption, photo: photo)
        }
    
}


class CameraView: UIViewController {
    
    var img: UIImage!
    var caption: String!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var button: UIButton!
    @IBOutlet var submitButton: UIButton!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        imageView.image = img
        
        let storageRef = Storage.storage().reference()
        
        let photoRef = storageRef.child("photos/\(UUID().uuidString).png")
        
        let ref = Database.database().reference()
        
        photoRef.putData(img.pngData()!, metadata: nil) { metadata, error in
            if let error = error {
                print("Error uploading photo: \(error.localizedDescription)")
            } else {
                let photoLink = "photos/\(metadata?.name! ?? "")"
                
                let newUpload = Upload(uploadID: "12345", groupID: "123", creatorID: "789", date: Date(), caption: "hi", photo: photoLink)
                
                let messageRef = ref.child("uploads").childByAutoId()

                messageRef.setValue(newUpload.toDictionary()) { error, ref in
                    if let error = error {
                        print("Error writing message: \(error)")
                    } else {
                        print("Message written to database")
                    }
                }
                
                
            }
        }
        
        
    }

    @IBAction func didTapButton() {
        
        print("TESSSSSIE")
    }
    
    func updateImg(image: UIImage) {
        self.img = image
    }
}


