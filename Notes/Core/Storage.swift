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

    private lazy var realm: Realm = {
        do {
            let realm = try Realm()
            return realm
        } catch let error {
            fatalError(error.localizedDescription)
        }
    }()

    func addNote(note: NoteDBModel) {
        save {
            self.realm.add(note)
        }
    }

    func fetchNotes() -> Results<NoteDBModel> {
        return realm.objects(NoteDBModel.self)
    }

    func deleteNote(with id: UUID) {
        if let result = noteModel(by: id) {
            save {
                self.realm.delete(result)
            }
        }
    }

    func editNote(note: NoteDBModel, newContent: String) {
        let noteId = note.id

        save {
            let note = self.realm.object(ofType: NoteDBModel.self, forPrimaryKey: noteId) ?? NoteDBModel(content: newContent)
            note.content = newContent
            self.realm.add(note, update: .modified)
        }
    }

    private func noteModel(by id: UUID) -> NoteDBModel? {
        return realm.object(ofType: NoteDBModel.self, forPrimaryKey: id)
    }

    private func save(closure: @escaping () -> Void) {
        storageQueue.async {
            try? self.realm.write(closure)
        }
    }
}
