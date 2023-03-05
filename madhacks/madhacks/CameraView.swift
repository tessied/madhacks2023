//
//  CameraView.swift
//  madhacks
//
//  Created by Stephanie Ran on 3/4/23.
//

import UIKit
import AVFoundation
import FirebaseDatabase
import FirebaseStorage

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


class CameraView: UIViewController, AVCapturePhotoCaptureDelegate {
    
    // Capture Session
    var session: AVCaptureSession?
    
    // Photo Output
    let output = AVCapturePhotoOutput()
    
    // Video Preview
    let previewLayer = AVCaptureVideoPreviewLayer()
    
    // Shutter button
    private let shutterButton: UIButton = {
        let button = UIButton(frame: CGRect(x:0, y:0, width:100, height:100))
        button.layer.cornerRadius = 50
        button.layer.borderWidth = 5
        button.layer.borderColor = UIColor.white.cgColor
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        view.layer.addSublayer(previewLayer)
        view.addSubview(shutterButton)
        
        checkCameraPermissions()
        
        shutterButton.addTarget(self, action: #selector(didTapTakePhoto), for: .touchUpInside)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer.frame = view.bounds
        
        shutterButton.center = CGPoint(x: view.frame.size.width/2,
                                       y: view.frame.size.height - 100)
    }
    
    private func checkCameraPermissions() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined:
            //Request
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                guard granted else {
                    return
                }
                DispatchQueue.main.async {
                    self?.setUpCamera()
                }
            }
            
        case .restricted:
            break
        case .denied:
            break
        case .authorized:
            setUpCamera()
        @unknown default:
            break
        }
    }
    
    private func setUpCamera() {
        let session = AVCaptureSession()
        if let device = AVCaptureDevice.default(for: .video) {
            do {
                let input = try AVCaptureDeviceInput(device: device)
                if session.canAddInput(input) {
                    session.addInput(input)
                }
                
                if session.canAddOutput(output) {
                    session.addOutput(output)
                }
                previewLayer.videoGravity = .resizeAspectFill
                previewLayer.session = session
                session.startRunning()
                self.session = session
                
            } catch {
                print(error)
            }
        }
        
    }
    
    @objc private func didTapTakePhoto() {
        output.capturePhoto(with: AVCapturePhotoSettings(),
                            delegate: self)
        
//        let photoData = output.fileDataRepresentation() else {
//            print("error converting photo")
//            return
//        }
        // Upload the photo
//        let storageRef = Storage.storage().reference()
//
//        if let photoUrl = output,
//           let photoData = try? Data(contentsOf: photoUrl),
//           let photo = UIImage(data: photoData) {
//
//            let photoRef = storageRef.child("photos/\(UUID().uuidString).png")
//
//            photoRef.putData(photoData, metadata: nil) { metadata, error in
//                if let error = error {
//                    print("Error uploading photo: \(error.localizedDescription)")
//                } else {
//                    let photoLink = "photos/\(metadata?.name! ?? "")"
//
//                    let newUpload = Upload(uploadID: "12345", groupID: "123", creatorID: "789", date: Date(), caption: "hi", photo: photoLink)
//
//                }
//            }
//        }
    }
}

extension CameraView {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let data = photo.fileDataRepresentation() else {
            return
        }
        print(data)
        
        let image = UIImage(data:data)
        
        session?.stopRunning()
        
        let imageView = UIImageView(image: image)
        
        imageView.contentMode = .scaleAspectFill
        imageView.frame = view.bounds
        view.addSubview(imageView)
    }
}


