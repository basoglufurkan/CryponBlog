//
//  FirestoreManager.swift
//  BlogApp
//
//  Created by Ming-Ta Yang on 2022/5/18.
//

import FirebaseFirestore

enum FirestoreKeys {
    enum Collection {
        static let posts = "posts"
    }
    
    enum Data {
        static let title = "title"
        static let viewCount = "viewCount"
        static let uniqueViewCount = "uniqueViewCount"
    }
}

final class FirestoreManager {
    
    enum Error: Swift.Error {
        case noValueOrMatchingTypeForKey(key: String)
    }
    
    private let db = Firestore.firestore()
    private let userDefaults = UserDefaults.standard
    
    private func getPostData<T>(for postID: String, dataKey: String) async -> Result<T, Swift.Error> {
        do {
            let data = try await db.collection(FirestoreKeys.Collection.posts).document(postID).getDocument().data()

            if let viewCount = data?[dataKey] as? T {
                return .success(viewCount)
            } else {
                return .failure(Error.noValueOrMatchingTypeForKey(key: FirestoreKeys.Data.viewCount))
            }
        } catch {
            return .failure(error)
        }
    }

    func getUniquePostViewCount(for postID: String) async -> Result<Int, Swift.Error> {
        await getPostData(for: postID, dataKey: FirestoreKeys.Data.uniqueViewCount)
    }


    func getPostViewCount(for postID: String) async -> Result<Int, Swift.Error> {
        await getPostData(for: postID, dataKey: FirestoreKeys.Data.viewCount)
    }

    func incrementPostViewCount(postID: String, postTitle: String) async -> Swift.Error? {

        var data: [String: Any] = [
            FirestoreKeys.Data.title: postTitle,
            FirestoreKeys.Data.viewCount: FieldValue.increment(Int64(1)),
        ]

        if !userDefaults.bool(forKey: postID) {
            data[FirestoreKeys.Data.uniqueViewCount] = FieldValue.increment(Int64(1))
        }

        do {
            try await db.collection(FirestoreKeys.Collection.posts).document(postID).setData(data, merge: true)
            userDefaults.set(true, forKey: postID)
            return nil

        } catch {
            return error
        }
    }
}
