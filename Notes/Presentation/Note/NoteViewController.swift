//
//  NoteViewController.swift
//  Notes
//
//  Created by Margarita Slesareva on 20.01.2023.
//

import UIKit
import RealmSwift

private enum Metrics {
    static let saveButtonHeight: CGFloat = 50
    static let spacing: CGFloat = 12

    static let noteTextViewFont: UIFont = .systemFont(ofSize: 30)

    static let backgroundColor: UIColor = .init(hex: 0xFFCDB2)
    static let textColor: UIColor = .init(hex: 0x6D6875)
}

final class NoteViewController: UIViewController {

    private let noteTextView = UITextView()
    private let saveButton = UIButton()
    private let storage: Storage
    private var noteId: UUID?

    init(storage: Storage) {
        self.storage = storage

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }

    func configure(with id: UUID?) {
        if let id {
            let note = storage.getNote(id: id)
            noteTextView.text = note?.content
            noteId = id
        }
    }

    private func setup() {
        addSubviews()
        configureSubviews()
    }

    private func addSubviews() {
        [noteTextView, saveButton].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let safeArea = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            noteTextView.topAnchor.constraint(equalTo: view.topAnchor),
            noteTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            noteTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            saveButton.topAnchor.constraint(equalTo: noteTextView.bottomAnchor),
            saveButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -Metrics.spacing),
            saveButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            saveButton.heightAnchor.constraint(equalToConstant: Metrics.saveButtonHeight)
        ])
    }

    private func configureSubviews() {
        view.backgroundColor = Metrics.backgroundColor
        
        noteTextView.font = Metrics.noteTextViewFont
        noteTextView.backgroundColor = Metrics.backgroundColor

        saveButton.setTitle("Сохранить", for: .normal)
        saveButton.setTitleColor(Metrics.textColor, for: .normal)
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }

    @objc private func saveButtonTapped() {
        guard let text = noteTextView.text else {
            return
        }

        DispatchQueue.global().async {
            if let id = self.noteId {
                self.storage.editNote(id: id, newContent: text)
            } else {
                self.storage.createNote(text: text)
            }
        }

        navigationController?.popViewController(animated: true)
    }
}
