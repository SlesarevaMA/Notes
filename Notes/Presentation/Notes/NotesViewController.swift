//
//  NotesViewController.swift
//  Notes
//
//  Created by Margarita Slesareva on 18.01.2023.
//

import UIKit
import RealmSwift

private enum LocalMetrics {
    static let plusButtonWidth: CGFloat = 50
    static let headerHeight: CGFloat = 28
    static let headerTitleLableXposition: CGFloat = 10
    static let spacing: CGFloat = 12

    static let backgroundColor: UIColor = .init(hex: 0xFBF8E8)

    static let headerTitleLable: UIFont = .systemFont(ofSize: 30)
}

final class NotesViewController: UIViewController, UITableViewDelegate {

    private weak var viewControllerFactory: ViewControllerFactory?
    
    private let tableView = UITableView()
    private let plusButton = UIButton()
    private var notes: Results<NoteDBModel>?
    private let storage = UserDefaults.standard
    private var isFirstLaunch: Bool {
        return !storage.bool(forKey: "isFirstLaunch")
    }

//    private var notes = [
//        "Ты снимаешь вечернее платье, стоя лицом к стене",
//        "И я вижу свежие шрамы на гладкой как бархат спине",
//        "Мне хочется плакать от боли или забыться во сне",
//        "Где твои крылья, которые так нравились мне?"
//    ]

    init(viewControllerFactory: ViewControllerFactory) {
        self.viewControllerFactory = viewControllerFactory

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        addNoteAtFirstLaunch()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getData()
    }

    private func setup() {
        addSubviews()
        prepareTableView()
        configureSubviews()
    }

    private func addSubviews() {
        [tableView, plusButton].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        plusButton.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)

        let guide = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            plusButton.topAnchor.constraint(equalTo: tableView.bottomAnchor),
            plusButton.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -LocalMetrics.spacing),
            plusButton.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
            plusButton.widthAnchor.constraint(equalTo: plusButton.heightAnchor),
            plusButton.widthAnchor.constraint(equalToConstant: LocalMetrics.plusButtonWidth)
        ])
    }

    private func prepareTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(NotesCell.self, forCellReuseIdentifier: NotesCell.reuseIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
    }

    private func configureSubviews() {
        view.backgroundColor = LocalMetrics.backgroundColor
        tableView.backgroundColor = LocalMetrics.backgroundColor

        plusButton.setImage(UIImage(named: "plus"), for: .normal)
    }

    @objc private func plusButtonTapped() {
        guard let noteViewController = viewControllerFactory?.getDetailViewcotroller() else {
            return
        }

        showDetailViewController(noteViewController, sender: nil)
    }

    private func getData() {
        notes = Storage.shared.fetchNotes()
        tableView.reloadData()
    }

    private func addNoteAtFirstLaunch() {
        if isFirstLaunch {
            Storage.shared.addNote(note: NoteDBModel(content: "Ты снимаешь вечернее платье, стоя лицом к стене"))
            storage.set(isFirstLaunch, forKey: "isFirstLaunch")
        }
    }
}

extension NotesViewController: UITableViewDataSource {

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
