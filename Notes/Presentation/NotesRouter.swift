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

    func showNotesViewController() {
        let listViewController = NotesListViewController()
        let presenter = NotesListPresenterImpl(
            view: listViewController,
            settings: SettingsImpl(),
            storage: Storage.shared,
            router: self
        )
        listViewController.output = presenter

        rootViewController.pushViewController(listViewController, animated: false)
    }

    func showNoteViewController(with noteId: UUID?) {
        let noteViewController = NoteViewController(router: self)
        noteViewController.configure(with: noteId)

        rootViewController.pushViewController(noteViewController, animated: true)
    }
}
