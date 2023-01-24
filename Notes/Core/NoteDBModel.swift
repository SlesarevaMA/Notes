//
//  NoteDBModel.swift
//  Notes
//
//  Created by Margarita Slesareva on 22.01.2023.
//

import RealmSwift
import Foundation

final class NoteDBModel: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: UUID
    @Persisted var content: String = ""
    @Persisted var date: Date

    convenience init(content: String, id: UUID = UUID(), date: Date = Date()) {
        self.init()

        self.content = content
        self.id = id
        self.date = date
    }
}
