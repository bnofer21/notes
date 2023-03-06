//
//  NoteView.swift
//  notes
//
//  Created by Юрий on 21.12.2022.
//

import UIKit

class EditNoteView: UIView {
    
    var bottomConstraint: NSLayoutConstraint!
    
    var viewModel: EditViewModelProtocol? {
        didSet {
            configure()
        }
    }
    
    var buttons = [UIButton]()
    
    var keyboardToolBar: UIToolbar = {
        let tool = UIToolbar()
        return tool
    }()
    
    var textView: UITextView = {
        let tv = UITextView()
        tv.font = .systemFont(ofSize: 17)
        tv.sizeToFit()
        tv.lineSpacing = 5
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
    }
    
    private func createBarButtons() {
        for i in 0..<Resources.BarEvent.allCases.count {
            let button = UIButton(type: .system)
            let conf = UIImage.SymbolConfiguration(pointSize: 25, weight: .regular, scale: .large)
            button.tag = i
            button.setImage(UIImage(systemName: Resources.BarEvent.allCases[i].rawValue, withConfiguration: conf)?.withRenderingMode(.alwaysTemplate), for: .normal)
            buttons.append(button)
        }
    }
    
    private func configureToolBar() {
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        var barButtons = [UIBarButtonItem]()
        createBarButtons()
        buttons.forEach{ barButtons.append(UIBarButtonItem(customView: $0))}
        keyboardToolBar.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: 44)
        
        keyboardToolBar.items = [barButtons[0], space, barButtons[1], space, barButtons[2]]
        textView.inputAccessoryView = keyboardToolBar
    }
    
    func setBarTargets(target: Any?, action: Selector) {
        buttons.forEach{ $0.addTarget(target, action: action, for: .touchUpInside) }
    }
    
    private func configure() {
        guard let viewModel = viewModel else { return }
        if let text = viewModel.text, text.string.isEmpty {
            setFontTextView()
        } else {
            textView.attributedText = viewModel.text
        }
    }
    
    private func setFontTextView() {
        let attributtedText = NSMutableAttributedString(attributedString: textView.attributedText)
        attributtedText.addAttribute(.font, value: UIFont.systemFont(ofSize: 17), range: NSRange(location: 0, length: attributtedText.length))
        textView.attributedText = attributtedText
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
        bottomConstraint = constraints.first(where: { $0.firstAttribute == .bottom || $0.secondItem as? UIView == self.textView })
    }
}

