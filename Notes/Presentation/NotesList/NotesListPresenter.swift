//
//  Presenter.swift
//  Notes
//
//  Created by Margarita Slesareva on 23.01.2023.
//

import Foundation
import RealmSwift

final class NotesListPresenterImpl {

    private weak var view: NotesListInput?

    private let storage = UserDefaults.standard
    private var isFirstLaunch: Bool {
        return !storage.bool(forKey: "isFirstLaunch")
    }

    init(view: NotesListInput) {
        self.view = view
    }
}
