//
//  Reviews.swift
//  Snacktacular
//
//  Created by John Zulewski on 11/9/20.
//

import Foundation
import Firebase

class Reviews {
    var reviewArray: [Review] = []
    var db: Firestore!
    
    init() {
        db = Firestore.firestore()
    }
    
    func loadData(spot: Spot, completed: @escaping () -> ()) {
        guard spot.documentID != "" else {
            return
        }
        db.collection("spots").document(spot.documentID).collection("reviews").addSnapshotListener { (querySnapshot, error) in
            guard error == nil else {
                print("Error: adding snapshot listener \(error!.localizedDescription)")
                return completed()
            }
            self.reviewArray = [] // clean out exisitn spotArrat since new data will load
            // there are querySnapshot!.documents.count documents in the snapshot
            for document in querySnapshot!.documents {
                let review = Review(dictionary: document.data())
                review.documentID = document.documentID
                self.reviewArray.append(review)
                
            }
            completed()
        }
    }
    
    
}
