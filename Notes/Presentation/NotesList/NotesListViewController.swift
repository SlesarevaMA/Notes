//
//  NotesViewController.swift
//  Notes
//
//  Created by Margarita Slesareva on 18.01.2023.
//

import UIKit

private enum LocalMetrics {
    static let plusButtonWidth: CGFloat = 44
    static let headerHeight: CGFloat = 28
    static let headerTitleLableXposition: CGFloat = 10
    static let spacing: CGFloat = 12

    static let plusButtonColor: UIColor = .init(hex: 0x6d6875)

    static let headerTitleLable: UIFont = .systemFont(ofSize: 30)
}

protocol NotesListInput: AnyObject {
    var notes: [NoteViewModel] { get set }

    func reloadData()
}

protocol NotesListOuput: AnyObject {
    func viewWillAppear()
    func viewDidRemoveNote(at index: Int)
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
        setupTitle()
        addSubviews()
        prepareTableView()
        configureSubviews()
    }

    private func setupTitle() {
        title = "Заметки"
        let navigationBar = navigationController?.navigationBar
        navigationBar?.prefersLargeTitles = true
    }

    private func addSubviews() {
        [tableView, plusButton].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        plusButton.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)

        let safeArea = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            plusButton.topAnchor.constraint(equalTo: tableView.bottomAnchor),
            plusButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -LocalMetrics.spacing),
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

        let index = indexPath.row
        notes.remove(at: indexPath.row)

        tableView.beginUpdates()
        tableView.deleteRows(at: [indexPath], with: .fade)
        tableView.endUpdates()

        output?.viewDidRemoveNote(at: index)
    }
}
