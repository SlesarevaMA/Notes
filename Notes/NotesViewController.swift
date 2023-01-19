//
//  NotesViewController.swift
//  Notes
//
//  Created by Margarita Slesareva on 18.01.2023.
//

import UIKit

final class NotesViewController: UIViewController, UITableViewDelegate {

    private let tableView = UITableView()
//    private var notesCells = [String]()
    private var notesCells = [
        "Ты снимаешь вечернее платье, стоя лицом к стене",
        "И я вижу свежие шрамы на гладкой как бархат спине",
        "Мне хочется плакать от боли или забыться во сне",
        "Где твои крылья, которые так нравились мне?"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }

    private func setup() {
        addSubviews()
        prepareTableView()
    }

    private func addSubviews() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func prepareTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(NotesCell.self, forCellReuseIdentifier: NotesCell.reuseIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
    }
}

extension NotesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notesCells.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: NotesCell.reuseIdentifier,
            for: indexPath
        ) as? NotesCell else {
            return UITableViewCell()
        }

        let model = notesCells[indexPath.row]
        cell.configure(with: model)
        
        return cell
    }
}
