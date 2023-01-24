//
//  Storage.swift
//  Notes
//
//  Created by Margarita Slesareva on 22.01.2023.
//

import Foundation
import RealmSwift

final class Storage {

    static let shared = Storage()

    private let storageQueue = DispatchQueue(label: "com.ritulya.storagequeue")

    func createNote(text: String) {
        save { realm in
            let note = NoteDBModel(content: text)
            realm.add(note)
        }
    }

    func fetchNotes() -> Results<NoteDBModel>? {
        return getMany()
    }

    func deleteNote(with id: UUID) {
        save { realm in
            if let note: NoteDBModel = self.get(primaryKey: id) {
                realm.delete(note)
            }
        }
    }

    func editNote(id: UUID, newContent: String) {
        save { realm in
            guard let note: NoteDBModel = self.get(primaryKey: id) else {
                return
            }

            note.content = newContent
            realm.add(note, update: .modified)
        }
    }

    func getNote(id: UUID) -> NoteDBModel? {
        return get(primaryKey: id)
    }

    private func get<T: Object>(primaryKey: UUID) -> T? {
        guard let realm = try? createRealm() else {
            return nil
        }

        return realm.object(ofType: T.self, forPrimaryKey: primaryKey)
    }

    private func getMany<T: RealmFetchable>() -> Results<T>? {
        guard let realm = try? createRealm() else {
            return nil
        }

        return realm.objects(T.self)
    }

    private func save(closure: @escaping (Realm) -> Void) {
//        storageQueue.async {
            do {
                let realm = try self.createRealm()
                try realm.write {
                    closure(realm)
                }
            } catch let error {
                fatalError(error.localizedDescription)
            }
//        }
    }

    private func createRealm() throws -> Realm {
        let configuration = Realm.Configuration(objectTypes: [NoteDBModel.self])
        return try Realm(configuration: configuration)
    }
}
