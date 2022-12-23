//
//  EditController.swift
//  notes
//
//  Created by Юрий on 21.12.2022.
//

import UIKit

class EditController: UIViewController {
    
    var note: Note
    var noteView = EditNoteView()
    
    var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Done", for: .normal)
        return button
    }()
    
    init(note: Note) {
        self.note = note
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        noteView.viewModel = NoteViewModel(note: note)
        view = noteView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTargets()
        setupView()
        setDelegates()
        showKeyboard()
    }
    
    private func setupView() {
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: saveButton)
    }
    
    private func addTargets() {
        saveButton.addTarget(self, action: #selector(hideKeyboard), for: .touchUpInside)
    }
    
    private func setDelegates() {
        noteView.textView.delegate = self
    }
    
    private func showKeyboard() {
        noteView.textView.becomeFirstResponder()
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
}

extension EditController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        guard !textView.text.isEmpty else { return }
        note.text = noteView.textView.text!
        note.name = String(noteView.textView.text.prefix(10))
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        var isNew = false
        guard !textView.text.isEmpty else { return }
        if let _ = note.date {
            isNew = false
        } else {
            isNew = true
        }
        note.date = Date.now
        DataManager.shared.saveNote(isNew: isNew, note: note) {
            if let rootvc = navigationController?.viewControllers.first as? MainController {
                if isNew {
                    rootvc.notes.insert(note, at: 0)
                }
                rootvc.updateData()
            }
        }
    }
}



