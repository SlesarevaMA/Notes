//
//  Storage.swift
//  Notes
//
//  Created by Margarita Slesareva on 22.01.2023.
//

import Foundation
import RealmSwift

protocol Storage: AnyObject {
    func createNote(text: String)
    func fetchNotes() -> Results<NoteDBModel>?
    func deleteNote(with id: UUID)
    func editNote(id: UUID, newContent: String)
    func getNote(id: UUID) -> NoteDBModel?
}

final class StorageImpl: Storage {

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
        do {
            let realm = try createRealm()
            try realm.write {
                closure(realm)
            }
        } catch let error {
            fatalError(error.localizedDescription)
        }
    }

    private func createRealm() throws -> Realm {
        let configuration = Realm.Configuration(objectTypes: [NoteDBModel.self])
        return try Realm(configuration: configuration)
    }
}
