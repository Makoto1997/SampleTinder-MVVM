//
//  User.swift
//  SampleTinder-MVVM
//
//  Created by Makoto on 2022/04/26.
//

import Foundation
import Firebase

final class User {
    
    var name: String
    var email: String
    var createdAt: Timestamp
    var uid: String
    var age: String
    var residence: String
    var hobby: String
    var introduction: String
    
    init(dic: [String: Any]) {
        
        self.name = dic["name"] as? String ?? ""
        self.email = dic["email"] as? String ?? ""
        self.createdAt = dic["createdAt"] as? Timestamp ?? Timestamp()
        self.uid = dic["uid"] as? String ?? ""
        self.age = dic["uid"] as? String ?? ""
        self.residence = dic["uid"] as? String ?? ""
        self.hobby = dic["uid"] as? String ?? ""
        self.introduction = dic["uid"] as? String ?? ""
    }
}
