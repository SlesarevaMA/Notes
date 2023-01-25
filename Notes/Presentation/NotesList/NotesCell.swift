//
//  NotesCell.swift
//  Notes
//
//  Created by Margarita Slesareva on 19.01.2023.
//

import UIKit

private enum Metrics {
    static let horizontalSpacing: CGFloat = 12
    static let verticalSpacing: CGFloat = 6
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
        setupSubviews()
        configureSubviews()
    }

    private func setupSubviews() {
        noteLabel.numberOfLines = 2
        addSubview(noteLabel)
        noteLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            noteLabel.topAnchor.constraint(equalTo: topAnchor, constant: Metrics.verticalSpacing),
            noteLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Metrics.horizontalSpacing),
            noteLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Metrics.verticalSpacing),
            noteLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Metrics.horizontalSpacing),

            noteLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: noteLabel.font.pointSize)
        ])
    }

    private func configureSubviews() {
        backgroundColor = GlobalMetrics.backgroundColor
        selectionStyle = .none

        noteLabel.font = .preferredFont(forTextStyle: .body)
        noteLabel.textColor = GlobalMetrics.textColor
    }
}
