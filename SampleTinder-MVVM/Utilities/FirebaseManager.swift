//
//  FirebaseManager.swift
//  SampleTinder-MVVM
//
//  Created by Makoto on 2022/04/22.
//

import Firebase
import FirebaseAuth
import FirebaseFirestore

final class FirebaseManager {
    
    private static let auth = Auth.auth()
    private static let db = Firestore.firestore()
    
    static func createUserToFireAuth(name: String, email: String, password: String, completion: @escaping (Result<String, Error>) -> ()) {
        
        auth.createUser(withEmail: email, password: password) { auth, err in
            
            if let err = err {
                print("Auth情報の保存に失敗しました。", err)
                completion(.failure(err))
                return
            }
            
            guard let uid = auth?.user.uid else { return }
            completion(.success(uid))
        }
    }
    
    static func setUserDataToFireStore(name: String, email: String, uid: String, completion: @escaping (Result<String, Error>) -> ()) {
        
        let document = ["name": name, "email": email, "uid": uid, "createdAt": Timestamp()] as [String : Any]
        
        db.collection("users").document(uid).setData(document) { err in
            
            if let err = err {
                print("FireStoreへの保存に失敗しました。", err)
                return
            }
        }
    }
}
