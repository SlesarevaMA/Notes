//
//  ViewControllerFactory.swift
//  Notes
//
//  Created by Margarita Slesareva on 21.01.2023.
//

import UIKit

final class ViewControllerFactory {

    func getMasterViewController() -> UIViewController {
        let masterController = NotesViewController(viewControllerFactory: self)

        return UINavigationController(rootViewController: masterController)
    }

    func getDetailViewcotroller() -> NoteViewController {
        let detailViewController = NoteViewController()
        return detailViewController
    }
}
