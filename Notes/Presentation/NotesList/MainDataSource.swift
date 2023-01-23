//
//  MainDataSource.swift
//  Notes
//
//  Created by Margarita Slesareva on 23.01.2023.
//

import Foundation

final class MainDataSource: UITableViewDataSource {

    private var notes: Results<NoteDBModel>?

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let noteViewController = viewControllerFactory?.getDetailViewcotroller() else {
            return
        }

        guard let note = notes?[indexPath.row] else {
            return
        }

        noteViewController.configure(with: note.content)
        showDetailViewController(noteViewController, sender: nil)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: LocalMetrics.headerHeight))

        let headerTitleLable = UILabel(
            frame: CGRect(
                x: LocalMetrics.headerTitleLableXposition,
                y: 0,
                width: header.frame.width,
                height: header.frame.height
            )
        )

        headerTitleLable.text = "Заметки"
        headerTitleLable.font = LocalMetrics.headerTitleLable
        headerTitleLable.textColor = GlobalMetrics.textColor

        header.addSubview(headerTitleLable)

        return header
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let notes {
            return notes.count
        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: NotesCell.reuseIdentifier,
            for: indexPath
        ) as? NotesCell else {
            return UITableViewCell()
        }

        guard let notes else {
            return UITableViewCell()
        }

        let model = notes[indexPath.row]
        cell.configure(with: model.content)

        return cell
    }

    func tableView(
        _ tableView: UITableView,
        editingStyleForRowAt indexPath: IndexPath
    ) -> UITableViewCell.EditingStyle {
        return .delete
    }

    func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ) {
        guard let notes else {
            return
        }

        guard editingStyle == .delete else {
            return
        }

        let note = notes[indexPath.row]
        Storage.shared.deleteNote(note: note)
        tableView.deleteRows(at: [indexPath], with: .fade)

        DispatchQueue.main.async {
            tableView.reloadData()
        }
    }
}
