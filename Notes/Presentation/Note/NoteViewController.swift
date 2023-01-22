//
//  NoteViewController.swift
//  Notes
//
//  Created by Margarita Slesareva on 20.01.2023.
//

import UIKit
import RealmSwift

private enum LocalMetrics {
    static let saveButtonHeight: CGFloat = 50
    static let spacing: CGFloat = 12

    static let noteTextViewFont: UIFont = .systemFont(ofSize: 30)

    static let backgroundColor: UIColor = .init(hex: 0xFBF8E8)
}

final class NoteViewController: UIViewController {

    private let noteTextView = UITextView()
    private let saveButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }

    func configure(with note: String) {
        noteTextView.text = note
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

        let guide = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            noteTextView.topAnchor.constraint(equalTo: view.topAnchor),
            noteTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            noteTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            saveButton.topAnchor.constraint(equalTo: noteTextView.bottomAnchor),
            saveButton.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -LocalMetrics.spacing),
            saveButton.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
            saveButton.heightAnchor.constraint(equalToConstant: LocalMetrics.saveButtonHeight)
        ])
    }

    private func configureSubviews() {
        view.backgroundColor = LocalMetrics.backgroundColor
        
        noteTextView.font = LocalMetrics.noteTextViewFont
        noteTextView.backgroundColor = LocalMetrics.backgroundColor

        saveButton.setTitle("Сохранить", for: .normal)
        saveButton.setTitleColor(.black, for: .normal)
    }

    @objc private func saveButtonTapped() {
        let note = NoteDBModel(content: noteTextView.text)

        Storage.shared.addNote(note: note)
    }
}
