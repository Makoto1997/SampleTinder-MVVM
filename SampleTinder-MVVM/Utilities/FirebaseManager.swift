//
//  FirebaseManager.swift
//  SampleTinder-MVVM
//
//  Created by Makoto on 2022/04/22.
//

import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

final class FirebaseManager {
    
    private static let auth = Auth.auth()
    private static let db = Firestore.firestore()
    
    static func authenticationStatusCheck() -> Bool {
        
        let userCheck = auth.currentUser == nil
        let isEmailVerified = auth.currentUser?.isEmailVerified ?? true
        if userCheck || !isEmailVerified {
            // 新規ユーザーの場合
            return false
        }else {
            // ログイン済みユーザーの場合
            return true
        }
    }
    
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
    
    static func setUserDataToFireStore(name: String, email: String, uid: String, completion: @escaping (_ err: Error?) -> ()) {
        
        let document = ["name": name, "email": email, "uid": uid, "createdAt": Timestamp()] as [String : Any]
        
        db.collection("users").document(uid).setData(document) { err in
            
            if let err = err {
                print("FireStoreへの保存に失敗しました。", err)
                completion(err)
                return
            }
            
            completion(nil)
        }
    }
    
    static func login(email: String, password: String, completion: @escaping (_ err: Error?) -> ()) {
        
        auth.signIn(withEmail: email, password: password) { res, err in
            
            if let err = err {
                print("ログインに失敗しました。", err)
                completion(err)
                return
            }
            completion(nil)
        }
    }
    
    static func logout(completion: @escaping (_ err: Error?) -> ()) {
        
        do {
            try auth.signOut()
        } catch {
            print("ログアウトに失敗しました。", error)
        }
    }
    
    static func fetchUserFromFireStore(completion: @escaping (Result<User, Error>) -> ()) {
        
        guard let uid = auth.currentUser?.uid else { return }
        // addSnapshotListenerで自動更新
        db.collection("users").document(uid).addSnapshotListener { snapshot, err in
            
            if let err = err {
                print("ユーザー情報の取得に失敗しました。")
                completion(.failure(err))
                return
            }
            
            guard let dic = snapshot?.data() else { return }
            let user = User(dic: dic)
            completion(.success(user))
        }
    }
    
    static func fetchUsersFromFireStore(completion: @escaping (Result<[User], Error>) -> ()) {
        
        db.collection("users").getDocuments { snapshots, err in
            
            if let err = err {
                print("ユーザー情報の取得に失敗しました。")
                completion(.failure(err))
                return
            }
            
            let users = snapshots?.documents.map({ snapshot -> User in
                
                let dic = snapshot.data()
                let user = User(dic: dic)
                return user
            })
            // 自分以外のユーザー
            let filterdUsers = users?.filter({ user -> Bool in
                
                return user.uid != auth.currentUser?.uid
            })
            
            completion(.success(filterdUsers ?? [User]()))
        }
    }
    
    static func updateUserInfo(dic: [String: Any], completion: @escaping (_ err: Error?) -> ()) {
        
        guard let uid = auth.currentUser?.uid else { return }
        db.collection("users").document(uid).updateData(dic) { err in
            
            if let err = err {
                print("ユーザー情報の取得に失敗しました。", err)
                completion(err)
                return
            }
            completion(nil)
        }
    }
    
    // Storage
    static func addProfileImageToStorage(image: UIImage, dic: [String: Any], completion: @escaping (_ err: Error?) -> ()) {
        
        guard let uploadImage = image.jpegData(compressionQuality: 0.3) else { return }
        let fileName = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("profileImage").child(fileName)
        // Storageへの保存
        storageRef.putData(uploadImage, metadata: nil) { metadata, err in
            
            if let err = err {
                print("画像の保存に失敗しました。", err)
                completion(err)
                return
            }
            // ダウンロード
            storageRef.downloadURL { url, err in
                
                if let err = err {
                    print("画像の取得に失敗しました。", err)
                    completion(err)
                    return
                }
                
                guard let urlString = url?.absoluteString else { return }
                var dicWithImage = dic
                dicWithImage["profileImageUrl"] = urlString
                // FireStoreへの保存
                updateUserInfo(dic: dicWithImage) { err in
                    
                    if let err = err {
                        print("画像の保存に失敗しました。", err)
                        completion(err)
                        return
                    }
                    
                    completion(nil)
                }
            }
        }
    }
}
