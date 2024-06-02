//
//  FirebaseStorageManager.swift
//  RealityObjectScan
//
//  Created by 홍승표 on 5/30/24.
//

import Foundation
import FirebaseStorage

class FirebaseStorageManager {
    static let shared = FirebaseStorageManager()
    private let storage = Storage.storage()
    
    @Published var scanModelName: String = ""
    private init() {}

    func downloadUSDZ(scanModelName: String, completion: @escaping (Result<URL, Error>) -> Void) {
        let storageRef = storage.reference()
        let scanRef = storageRef.child("scan/\(scanModelName).usdz")
        // 임시 디렉토리 경로를 생성
        let localURL = FileManager.default.temporaryDirectory.appendingPathComponent("\(scanModelName).usdz")
        
        // 파일 다운로드를 시작
        scanRef.write(toFile: localURL) { url, error in
            if let error = error {
                print("USDZ 파일 다운로드 중 오류 발생: \(error)")
                completion(.failure(error))
            } else if let url = url {
                print("USDZ 파일이 성공적으로 다운로드되었습니다: \(url)")
                completion(.success(url))
            }
        }
    }
}
