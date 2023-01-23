//
//  NotesCell.swift
//  Notes
//
//  Created by Margarita Slesareva on 19.01.2023.
//

import UIKit

private enum LocalMetrics {
    static let spacing: CGFloat = 12

    static let noteLabelFont: UIFont = .boldSystemFont(ofSize: 26)
}

final class NotesCell: UITableViewCell {

    private let noteLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with model: String) {
        noteLabel.text = model
    }

    private func setup() {
        addSubviews()
        configureSubviews()
    }

    private func addSubviews() {
        addSubview(noteLabel)
        noteLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            noteLabel.topAnchor.constraint(equalTo: topAnchor, constant: LocalMetrics.spacing),
            noteLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: LocalMetrics.spacing),
            noteLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -LocalMetrics.spacing),
            noteLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -LocalMetrics.spacing)
        ])
    }

    private func configureSubviews() {
        backgroundColor = GlobalMetrics.backgroundColor
        selectionStyle = .none

        noteLabel.font = LocalMetrics.noteLabelFont
        noteLabel.textColor = GlobalMetrics.textColor
    }
}
