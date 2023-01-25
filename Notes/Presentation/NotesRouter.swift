//
//  NotesRouter.swift
//  Notes
//
//  Created by Margarita Slesareva on 21.01.2023.
//

import UIKit

protocol NotesRouter: AnyObject {
    var rootViewController: UINavigationController { get }

    func showNotesViewController()
    func showNoteViewController(with noteId: UUID?)
}

final class NotesRouterImpl: NotesRouter {
    let rootViewController = UINavigationController()

    private let storage: Storage = StorageImpl()
    private let settings: Settings = SettingsImpl()

    func showNotesViewController() {
        let listViewController = NotesListViewController()
        let presenter = NotesListPresenterImpl(
            view: listViewController,
            settings: settings,
            storage: storage,
            router: self
        )
        listViewController.output = presenter

        rootViewController.pushViewController(listViewController, animated: false)
    }

    func showNoteViewController(with noteId: UUID?) {
        let noteViewController = NoteViewController(storage: storage)
        noteViewController.configure(with: noteId)

        rootViewController.pushViewController(noteViewController, animated: true)
    }
}
