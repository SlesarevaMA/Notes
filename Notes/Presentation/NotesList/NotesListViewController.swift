//
//  NotesViewController.swift
//  Notes
//
//  Created by Margarita Slesareva on 18.01.2023.
//

import UIKit

private enum LocalMetrics {
    static let plusButtonWidth: CGFloat = 50
    static let headerHeight: CGFloat = 28
    static let headerTitleLableXposition: CGFloat = 10
    static let spacing: CGFloat = 12

    static let plusButtonColor: UIColor = .init(hex: 0xE5989B)

    static let headerTitleLable: UIFont = .systemFont(ofSize: 30)
}

protocol NotesListInput: AnyObject {
//    func setTableViewDataSource(dataSourse: UITableViewDataSource)
    var notes: [NoteViewModel] { get set }

    func reloadData()
}

protocol NotesListOuput: AnyObject {
    func viewWillAppear()
}

final class NotesListViewController: UIViewController, UITableViewDelegate, NotesListInput {

    var output: NotesListOuput?

    var notes = [NoteViewModel]()

    private weak var viewControllerFactory: ViewControllerFactory?
    private let tableView = UITableView()
    private let plusButton = UIButton()

    init(viewControllerFactory: ViewControllerFactory) {
        self.viewControllerFactory = viewControllerFactory

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        output?.viewWillAppear()
    }

    func reloadData() {
        tableView.reloadData()
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
            plusButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -LocalMetrics.spacing),
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
        view.backgroundColor = GlobalMetrics.backgroundColor
        tableView.backgroundColor = GlobalMetrics.backgroundColor

        plusButton.setImage(UIImage(named: "plus"), for: .normal)
        plusButton.tintColor = LocalMetrics.plusButtonColor
    }

    @objc private func plusButtonTapped() {
        guard let noteViewController = viewControllerFactory?.getDetailViewcotroller() else {
            return
        }

        showDetailViewController(noteViewController, sender: nil)
    }

//    private func getData() {
//        notes = Storage.shared.fetchNotes()
//        tableView.reloadData()
//    }

//    private func addNoteAtFirstLaunch() {
//        if isFirstLaunch {
//            Storage.shared.addNote(note: NoteDBModel(content: "Ты снимаешь вечернее платье, стоя лицом к стене"))
//            storage.set(isFirstLaunch, forKey: "isFirstLaunch")
//        }
//    }
}

extension NotesListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let noteViewController = viewControllerFactory?.getDetailViewcotroller() else {
            return
        }

        let note = notes[indexPath.row]
        noteViewController.configure(with: note.note)
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
        cell.configure(with: model.note)

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

        guard editingStyle == .delete else {
            return
        }

        let note = notes[indexPath.row]
//        Storage.shared.deleteNote(note: note)

        tableView.beginUpdates()
        tableView.deleteRows(at: [indexPath], with: .fade)
        tableView.endUpdates()
    }
}
