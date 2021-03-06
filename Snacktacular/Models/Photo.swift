//
//  Photo.swift
//  Snacktacular
//
//  Created by John Zulewski on 11/16/20.
//

import UIKit
import Firebase

class Photo {
    var image: UIImage
    var description: String
    var photoUserID: String
    var photoUserEmail: String
    var date: Date
    var photoURL: String
    var documentID: String
    
    var dictionary: [String: Any] {
        let timeIntervalDate = date.timeIntervalSince1970
        return ["description": description, "photoUserID": photoUserID, "photoUserEmail": photoUserEmail, "date": timeIntervalDate, "photoURL": photoURL, "documentID": documentID]
    }

    init(image: UIImage, description: String, photoUserID: String, photoUserEmail: String, date: Date, photoURL: String, documentID: String) {
        
        self.image = image
        self.description = description
        self.photoUserID = photoUserID
        self.photoUserEmail = photoUserEmail
        self.date = date
        self.photoURL = photoURL
        self.documentID = documentID
        
    }


    convenience init() {
        let photoUserID = Auth.auth().currentUser?.uid ?? ""
        let photoUserEmail = Auth.auth().currentUser?.email ?? "unknown email"
        self.init(image: UIImage(), description: "", photoUserID: photoUserID, photoUserEmail: photoUserEmail, date: Date(), photoURL: "", documentID: "")
        
    }

    convenience init(dictionary: [String: Any]) {
        let description = dictionary["description"] as! String? ?? ""
        let photoUserID = dictionary["photoUserID"] as! String? ?? ""
        let photoUserEmail = dictionary["photoUserEmail"] as! String? ?? ""
        let date = Date(timeIntervalSince1970: timeIntervalDate)
        let photoURL = dictionary["photoURL"] as! String? ?? ""
    
        
        self.init(image: UIImage(), description: description, photoUserID: photoUserID, photoUserEmail: photoUserEmail, date: date, photoURL: photoUserID, documentID: "")

    }
    
    func saveData(spot: Spot, completion: @escaping (Bool) -> ()) {
        let db = Firestore.firestore()
        let storage = Storage.storage()
        
        // convert photo.image to a Data type so it can be saved to Firebase Storage
        guard let photoData = self.image.jpegData(compressionQuality: 0.5) else {
            print("Error: Could not convert photo.iamge to Data")
            return
        }
        
        // create metadata to see in Firebase Storage
        let uploadMetaData = StorageMetadata()
        uploadMetaData.contentType = "image/jpeg"
        
        // create filename if neccessary {
        if documentID == "" {
            documentID = UUID().uuidString
        }
        
        // create a storage ref to uploda this mage to the spot's folder
        let storageRef = storage.reference().child(spot.documentID).child(documentID)
        
        // create an uploadTask
        let uploadTask = storageRef.putData(photoData, metadata: uploadMetaData) { (metadata, error) in
            if let  error = error {
                print("Error upload for ref \(uploadMetaData) failed. \(error.localizedDescription)")
            }
        }
        
        uploadTask.observe(.success) { (snapshot) in
            print("upload successful")
            
            storageRef.downloadURL { (url, error) in
                guard error == nil else {
                    print("Error: Couldn't create a download url \(error!.localizedDescription)")
                    return completion(false)
                }
                guard let url = url else {
                    print("Error: Url was nil \(error!.localizedDescription)")
                    return completion(false)
                }
                self.photoURL = "\(url)"
                
                let dataToSave: [String: Any] = self.dictionary
                
                let ref = db.collection("spots").document(spot.documentID).collection("photos").document(self.documentID)
                ref.setData(dataToSave) { (error) in
                    guard error == nil else {
                        print("Error: updating document \(error!.localizedDescription)")
                        return completion(false)
                        
                    }
                    print("Updated document: \(self.documentID) in spot: \(spot.documentID)")
                    completion(true)
                }
            }
            
        }
        
        uploadTask.observe(.failure) { (snapshot) in
            if let error = snapshot.error {
                print("Error upload task for file \(self.documentID) failed in spot \(spot.documentID) with error \(error.localizedDescription)")
            }
            completion(false)
        }
        
    }
    
    func loadImage(spot: Spot, completion: @escaping (Bool) -> ()) {
        guard spot.documentID != "" else {
            print("Error: Did not pass valid spot into loadImage")
            return
        }
        let storage = Storage.storage()
        let storageRef = storage.reference().child(spot.documentID).child(documentID)
        storageRef.getData(maxSize: 25 * 1024 * 1024) { (data, error) in
            if let error = error {
                print("Error: an error occured while reading data from file ref \(storageRef) error = \(error.localizedDescription)")
                return completion(false)
            } else {
                self.image = UIImage(data: data!) ?? UIImage()
                return completion(true)
            }
        }
    }
    
    func deleteData(spot: Spot, completion: @escaping (Bool) -> ()) {
        let db = Firestore.firestore()
        db.collection("spots").document(spot.documentID).collection("photos")
            .document(documentID).delete { (error) in
                if let error = error {
                    print("Error: deleting photo documentID \(self.documentID). Error \(error.localizedDescription)")
                    completion(false)
                } else {
                    self.deleteImage(spot)
                    print("Successfully deleted document \(self.documentID)")
                        completion(true)
                    
                }
                
            }
    }
    
    private func deleteImage(spot: Spot) {
        guard spot.documentID != "" else {
            print("Error: did not pass a valid spot into deleteImage")
            return
        }
        let storage = Storage.storage()
        let storageRef = storage.reference().child(spot.documentID).child(documentID)
        storageRef.delete { (error) in
            if let error = error {
                print("Error: Could not delete photo \(error.localizedDescription)")

            } else {
                print("Photo successfully deleted!")
            }
            
        }
    }
}




