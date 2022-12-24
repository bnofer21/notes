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
    
    var keyboardToolBar: UIToolbar = {
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
    
    var smallerFont: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "textformat.size.smaller"), for: .normal)
        return button
    }()
    
    var biggerFont: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "textformat.size.larger"), for: .normal)
        return button
    }()
    
    var textView: UITextView = {
        let tv = UITextView()
        tv.font = .systemFont(ofSize: 17)
        tv.sizeToFit()
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
        addView(keyboardToolBar)
        textView.inputAccessoryView = keyboardToolBar
    }
    
    private func setFontTextView() {
        let attributtedText = NSMutableAttributedString(attributedString: textView.attributedText)
        attributtedText.addAttribute(.font, value: UIFont.systemFont(ofSize: 17), range: NSRange(location: 0, length: attributtedText.length))
        textView.attributedText = attributtedText
    }
    
    private func configureToolBar() {
        let cameraBar = UIBarButtonItem(customView: addImageButton)
        let boldText = UIBarButtonItem(customView: makeBoldText)
        let smallFont = UIBarButtonItem(customView: smallerFont)
        let bigFont = UIBarButtonItem(customView: biggerFont)
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        keyboardToolBar.items = [boldText, flexSpace, bigFont, flexSpace,smallFont, flexSpace, cameraBar]
    }
    
    func setTextTarget(target: Any?, action: Selector) {
        makeBoldText.addTarget(target, action: action, for: .touchUpInside)
    }
    
    func setChangeFontTarget(target: Any?, action: Selector) {
        smallerFont.addTarget(target, action: action, for: .touchUpInside)
    }
    
    private func configure() {
        guard let viewModel = viewModel else { return }
        print(viewModel.text.attributes(at: 0, effectiveRange: nil))
        if viewModel.text.string.isEmpty {
            setFontTextView()
        } else {
            textView.attributedText = viewModel.text
        }
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
            
        ])
    }
}

