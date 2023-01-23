//
//  Presenter.swift
//  Notes
//
//  Created by Margarita Slesareva on 23.01.2023.
//

import Foundation
import RealmSwift

private enum Constants {
    static let defaultNote = "Ты снимаешь вечернее платье, стоя лицом к стене"
    static let firstLaunchKey = "isFirstLunch"
}

final class NotesListPresenterImpl {

    private var models = [NoteDBModel]()
    private weak var view: NotesListInput?
    private let settings: Settings
    private let storage: Storage
    private let presenterQueue = DispatchQueue(label: "com.ritulya.notesPresenterQueue")

    private var isFirstLunch: Bool {
        get {
            return settings.getValue(for: Constants.firstLaunchKey) ?? true
        }

        set {
            settings.setValue(value: newValue, for: Constants.firstLaunchKey)
        }
    }

    init(view: NotesListInput, settings: Settings, storage: Storage) {
        self.view = view
        self.settings = settings
        self.storage = storage
    }

    private func fetchNotes() {
        let notes = storage.fetchNotes()
        models = Array(notes)
            .sorted(by: { $0.date > $1.date })
        let viewModels = models
            .map { NoteViewModel(note: $0.content) }

        DispatchQueue.main.async {
            self.view?.notes = viewModels
            self.view?.reloadData()
        }
    }

    private func createFirstNoteIfNeeded() {
        if isFirstLunch {
            storage.addNote(note: NoteDBModel(content: Constants.defaultNote))
            isFirstLunch = false
        }
    }
}

extension NotesListPresenterImpl: NotesListOuput {
    func viewWillAppear() {
        presenterQueue.async {
            self.createFirstNoteIfNeeded()
            self.fetchNotes()
        }
    }

    func viewDidRemoveNote(at index: Int) {
        presenterQueue.async {
            let modelId = self.models.remove(at: index).id
            self.storage.deleteNote(with: modelId)
        }
    }
}
