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
    
    var bottomToolBar: UIToolbar = {
        let tool = UIToolbar()
        return tool
    }()
    
    var addImageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "camera"), for: .normal)
        return button
    }()
    
    var makeBoldText: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "bold"), for: .normal)
        return button
    }()
    
    var textView: UITextView = {
        let tv = UITextView()
        tv.font = .systemFont(ofSize: 17)
        return tv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setConstraints()
        configureToolBar()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .systemBackground
        addView(textView)
        addView(bottomToolBar)
    }
    
    private func configureToolBar() {
        let cameraBar = UIBarButtonItem(customView: addImageButton)
        let boldText = UIBarButtonItem(customView: makeBoldText)
        bottomToolBar.items = [boldText ,cameraBar]
    }
    
    private func setImageTarget(target: Any?, action: Selector) {
        addImageButton.addTarget(target, action: action, for: .touchUpInside)
    }
    
    func setTextTarget(target: Any?, action: Selector) {
        makeBoldText.addTarget(target, action: action, for: .touchUpInside)
    }
    
    private func configure() {
        textView.attributedText = viewModel?.text
    }
    
    func createActionsMenu(actions: [UIAction]) {
        addImageButton.menu = UIMenu(title: "", children: actions)
        addImageButton.showsMenuAsPrimaryAction = true
    }
    
    
}

extension EditNoteView {
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 5),
            textView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30),
            textView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            textView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            bottomToolBar.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            bottomToolBar.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            bottomToolBar.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}

