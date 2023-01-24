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

    private weak var view: NotesListInput?
    private let settings: Settings
    private let storage: Storage
    private let router: NotesRouter

    private let presenterQueue = DispatchQueue(label: "com.ritulya.notesPresenterQueue")

    private var isFirstLunch: Bool {
        get {
            return settings.getValue(for: Constants.firstLaunchKey) ?? true
        }

        set {
            settings.setValue(value: newValue, for: Constants.firstLaunchKey)
        }
    }
    private var noteIds = [UUID]()

    init(view: NotesListInput, settings: Settings, storage: Storage, router: NotesRouter) {
        self.view = view
        self.settings = settings
        self.storage = storage
        self.router = router
    }

    private func fetchNotes() {
        guard let notesResults = storage.fetchNotes() else {
            return
        }
        
        let notes = Array(notesResults)
            .sorted(by: { $0.date > $1.date })

        self.noteIds = notes.map { $0.id }
        let viewModels = notes.map { NoteViewModel(note: $0.content) }

        DispatchQueue.main.async {
            self.view?.notes = viewModels
            self.view?.reloadData()
        }
    }

    private func createFirstNoteIfNeeded() {
        if isFirstLunch {
            storage.createNote(text: Constants.defaultNote)
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

    func viewDidTapPlusButton() {
        router.showNoteViewController(with: nil)
    }

    func viewDidTapNote(at index: Int) {
        let noteId = noteIds[index]
        router.showNoteViewController(with: noteId)
    }

    func viewDidRemoveNote(at index: Int) {
        presenterQueue.async {
            let modelId = self.noteIds.remove(at: index)
            self.storage.deleteNote(with: modelId)
        }
    }
}
