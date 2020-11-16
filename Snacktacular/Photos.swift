//
//  Photos.swift
//  Snacktacular
//
//  Created by John Zulewski on 11/16/20.
//

import Foundation
import Firebase

class Photos {
    var photoArray: [Photo] = []
    var db: Firestore!
    
    init() {
        db = Firestore.firestore()
    }
    
    func loadData(spot: Spot, completed: @escaping () -> ()) {
        guard spot.documentID != "" else {
            return
        }
        db.collection("spots").document(spot.documentID).collection("photos").addSnapshotListener { (querySnapshot, error) in
            guard error == nil else {
                print("Error: adding snapshot listener \(error!.localizedDescription)")
                return completed()
            }
            self.photoArray = [] // clean out exisitn spotArrat since new data will load
            // there are querySnapshot!.documents.count documents in the snapshot
            for document in querySnapshot!.documents {
                let photo = Photo(dictionary: document.data())
                photo.documentID = document.documentID
                self.photoArray.append(photo)
                
            }
            completed()
        }
    }
    
    
}
