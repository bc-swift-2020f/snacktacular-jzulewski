//
//  SnackUsers.swift
//  Snacktacular
//
//  Created by John Zulewski on 11/30/20.
//

import Foundation
import Firebase

class SnackUsers {
    var userArray: [SnackUser] = []
    var db: Firestore!
    
    init() {
        db = Firestore.firestore()
    }
    
    func loadData(completed: @escaping () -> ()) {
        db.collection("users").addSnapshotListener { (querySnapshot, error) in
            guard error == nil else {
                print("Error: adding snapshot listener \(error!.localizedDescription)")
                return completed()
            }
            self.userArray = [] // clean out exisitn userArray since new data will load
            // there are querySnapshot!.documents.count documents in the snapshot
            for document in querySnapshot!.documents {
                let snackUser = SnackUser(dictionary: document.data())
                snackUser.documentID = document.documentID
                self.userArray.append(snackUser)
                
            }
            completed()
        }
    }
}

