//
//  FirestoreServices.swift
//  Spritfill
//
//  Created by Edmond Wu on 2025-06-05.
//

import FirebaseFirestore
import Foundation

class FirestoreService {
    private let db = Firestore.firestore()
    private let collection = "projects"

    func saveProject(_ project: ProjectData, completion: @escaping (Error?) -> Void) {
        db.collection(collection).document(project.id.uuidString)
            .setData(project.toFirestoreDict) { error in
                completion(error)
            }
    }

    func fetchAllProjects(completion: @escaping ([ProjectData]) -> Void) {
        db.collection(collection).getDocuments { snapshot, error in
            guard let docs = snapshot?.documents else {
                completion([])
                return
            }

            let projects = docs.compactMap { ProjectData(from: $0) }
            completion(projects)
        }
    }

    func deleteProject(_ project: ProjectData, completion: @escaping (Error?) -> Void) {
        db.collection(collection).document(project.id.uuidString).delete(completion: completion)
    }

    func fetchProject(by id: UUID, completion: @escaping (ProjectData?) -> Void) {
        db.collection(collection).document(id.uuidString).getDocument { doc, _ in
            guard let doc = doc, doc.exists else {
                completion(nil)
                return
            }
            completion(ProjectData(from: doc))
        }
    }
}
