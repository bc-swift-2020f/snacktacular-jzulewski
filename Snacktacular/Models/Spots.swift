//
//  Spots.swift
//  Snacktacular
//
//  Created by John Zulewski on 11/2/20.
//

import Foundation
import Firebase

class Spots {
    var spotArray: [Spot] = []
    var db: Firestore!
    
    init() {
        db = Firestore.firestore()
    }
    
    func loadData(completed: @escaping () -> ()) {
        db.collection("spots").addSnapshotListener { (querySnapshot, error) in
            guard error == nil else {
                print("Error: adding snapshot listener \(error!.localizedDescription)")
                return completed()
            }
            self.spotArray = [] // clean out exisitn spotArrat since new data will load
            // there are querySnapshot!.documents.count documents in the snapshot
            for document in querySnapshot!.documents {
                let spot = Spot(dictionary: document.data())
                spot.documentID = document.documentID
                self.spotArray.append(spot)
                
            }
            completed()
        }
    }
}
