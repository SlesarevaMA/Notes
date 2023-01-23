//
//  Storage.swift
//  Notes
//
//  Created by Margarita Slesareva on 22.01.2023.
//

import Foundation
import RealmSwift

class Storage {

    static let shared = Storage()

    private var realm: Realm {
        do {
            let realm = try Realm()
            return realm
        } catch let error {
            fatalError(error.localizedDescription)
        }
    }

    func addNote(note: NoteDBModel) {
        try? realm.write {
            realm.add(note)
        }
    }

    func fetchNotes() -> Results<NoteDBModel> {
        return realm.objects(NoteDBModel.self)
    }

    func deleteNote(note: NoteDBModel) {
        try? realm.write {
            realm.delete(note)
        }
    }

    func editNote(note: NoteDBModel, newContent: String) {
        try? realm.write {
            note.content = newContent
            realm.add(note, update: .modified)
        }
    }
}
