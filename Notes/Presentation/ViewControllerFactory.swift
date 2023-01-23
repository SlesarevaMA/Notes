//
//  ViewControllerFactory.swift
//  Notes
//
//  Created by Margarita Slesareva on 21.01.2023.
//

import UIKit

final class ViewControllerFactory {

    func getMasterViewController() -> UIViewController {
        let listViewController = NotesListViewController(viewControllerFactory: self)
        let presenter = NotesListPresenterImpl(
            view: listViewController,
            settings: SettingsImpl(),
            storage: Storage.shared
        )
        listViewController.output = presenter

        return UINavigationController(rootViewController: listViewController)
    }

    func getDetailViewcotroller() -> NoteViewController {
        let detailViewController = NoteViewController()
        return detailViewController
    }
}
