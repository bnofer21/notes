//
//  NoteView.swift
//  notes
//
//  Created by Юрий on 21.12.2022.
//

import UIKit

class EditNoteView: UIView {
    
    var viewModel: NoteViewModel? {
        didSet {
            configure()
        }
    }
    
    var textView: UITextView = {
        let tv = UITextView()
        tv.font = .systemFont(ofSize: 17)
        return tv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .systemBackground
        addView(textView)
    }
    
    private func configure() {
        textView.text = viewModel?.text
    }
    
    
}

extension EditNoteView {
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 5),
            textView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30),
            textView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            textView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
        ])
    }
}

