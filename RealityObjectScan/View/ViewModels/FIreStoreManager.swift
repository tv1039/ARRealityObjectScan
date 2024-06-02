//
//  FIrestoreManager.swift
//  RealityObjectScan
//
//  Created by 홍승표 on 6/2/24.
//

import Foundation
import FirebaseFirestore

class FireStoreManager {
    static let shared = FireStoreManager()
    private let db = Firestore.firestore()
    
    private init() {}
    
    // Firestore에서 objectName을 통해 객체 정보를 가져오는 함수
    func getObjectInfo(objectName: String, completion: @escaping (ObjectModel?, Error?) -> Void) {
        db.collection("object").whereField("name", isEqualTo: objectName).getDocuments { (snapshot, error) in
            if let error = error {
                print("문서 가져오기 오류: \(error)")
                completion(nil, error)
            } else if let snapshot = snapshot, !snapshot.isEmpty {
                do {
                    // 첫 번째 문서를 사용 (name이 고유하다고 가정)
                    if let document = snapshot.documents.first {
                        let data = try JSONSerialization.data(withJSONObject: document.data(), options: [])
                        let decoder = JSONDecoder()
                        let object = try decoder.decode(ObjectModel.self, from: data)
                        completion(object, nil)
                    } else {
                        print("이름 \(objectName)과 일치하는 문서가 없음")
                        completion(nil, nil)
                    }
                } catch {
                    print("디코딩 오류: \(error)")
                    completion(nil, error)
                }
            } else {
                print("이름 \(objectName)과 일치하는 문서가 없음")
                completion(nil, nil)
            }
        }
    }
}
