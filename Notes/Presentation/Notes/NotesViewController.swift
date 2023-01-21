//
//  NotesViewController.swift
//  Notes
//
//  Created by Margarita Slesareva on 18.01.2023.
//

import UIKit

final class NotesViewController: UIViewController, UITableViewDelegate {

    private weak var viewControllerFactory: ViewControllerFactory?
    
    private let tableView = UITableView()
//    private var notesCells = [String]()
    private var notes = [
        "Ты снимаешь вечернее платье, стоя лицом к стене",
        "И я вижу свежие шрамы на гладкой как бархат спине",
        "Мне хочется плакать от боли или забыться во сне",
        "Где твои крылья, которые так нравились мне?"
    ]

    init(viewControllerFactory: ViewControllerFactory) {
        self.viewControllerFactory = viewControllerFactory

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

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

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let noteViewController = viewControllerFactory?.getDetailViewcotroller() else {
            return
        }

        let note = notes[indexPath.row]

        noteViewController.configure(with: note)
        showDetailViewController(noteViewController, sender: nil)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 28))

        let headerTitleLable = UILabel(
            frame: CGRect(
                x: 10,
                y: 0,
                width: header.frame.width - 10,
                height: header.frame.height
            )
        )
        headerTitleLable.text = "Заметки"
        headerTitleLable.font = .systemFont(ofSize: 30)

        header.addSubview(headerTitleLable)

        return header
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: NotesCell.reuseIdentifier,
            for: indexPath
        ) as? NotesCell else {
            return UITableViewCell()
        }

        let model = notes[indexPath.row]
        cell.configure(with: model)
        
        return cell
    }
}
