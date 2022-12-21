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
        button.setTitle("Save", for: .normal)
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
    }
    
    private func setupView() {
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: saveButton)
    }
    
    private func addTargets() {
        saveButton.addTarget(self, action: #selector(saveNote), for: .touchUpInside)
    }
    
    @objc func saveNote() {
        guard !noteView.textView.text.isEmpty else { return }
        if let text = note.text, !text.isEmpty {
            note.text = noteView.textView.text!
            note.name = String(noteView.textView.text.prefix(10))
            DataManager.shared.updateValues {
                if let rootvc = navigationController?.viewControllers.first as? MainController {
                    DataManager.shared.loadNotes { notes in
                        rootvc.notes = notes
                        rootvc.notesView.notesTableView.reloadData()
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                }
            }
        } else {
            note.text = noteView.textView.text!
            note.name = String(noteView.textView.text.prefix(10))
            DataManager.shared.saveNote(note: note) {
                if let rootvc = navigationController?.viewControllers.first as? MainController {
                    DataManager.shared.loadNotes { notes in
                        rootvc.notes = notes
                        rootvc.notesView.notesTableView.reloadData()
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                }
            }
        }
    }
    
}
