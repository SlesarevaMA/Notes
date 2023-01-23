//
//  NoteDBModel.swift
//  Notes
//
//  Created by Margarita Slesareva on 22.01.2023.
//

import RealmSwift
import Foundation

final class NoteDBModel: Object, ObjectKeyIdentifiable {
    
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var content: String = ""

    convenience init(content: String) {
        self.init()
        self.content = content
    }
}
