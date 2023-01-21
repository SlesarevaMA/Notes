//
//  NoteViewController.swift
//  Notes
//
//  Created by Margarita Slesareva on 20.01.2023.
//

import UIKit

private enum LocalMetrics {
    static let noteTextViewFont: UIFont = .systemFont(ofSize: 30)
}

final class NoteViewController: UIViewController {

    private let noteTextView = UITextView()

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
        view.addSubview(noteTextView)
        noteTextView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            noteTextView.topAnchor.constraint(equalTo: view.topAnchor),
            noteTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            noteTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            noteTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func configureSubviews() {
        noteTextView.font = LocalMetrics.noteTextViewFont
    }
}
