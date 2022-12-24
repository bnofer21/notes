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
        createActionsMenu()
    }
    
    private func setupView() {
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: saveButton)
    }
    
    private func createActionsMenu() {
        let imageFromCamera = UIAction(title: "Camera", image: UIImage(systemName: "camera")) { _ in
            self.photoPickerPresent(type: .camera)
        }
        let imageFromGallery = UIAction(title: "From gallery", image: UIImage(systemName: "photo.on.rectangle")) { _ in
            self.photoPickerPresent(type: .gallery)
        }
        noteView.createActionsMenu(actions: [imageFromCamera, imageFromGallery])
    }
    
    private func addTargets() {
        saveButton.addTarget(self, action: #selector(hideKeyboard), for: .touchUpInside)
        noteView.setTextTarget(target: self, action: #selector(makeBold))
    }
    
    private func setDelegates() {
        noteView.textView.delegate = self
    }
    
    private func showKeyboard() {
        noteView.textView.becomeFirstResponder()
    }
    
    private func photoPickerPresent(type: Resources.PhotoType) {
        let vc = UIImagePickerController()
        if type == .camera {
            vc.sourceType = .camera
        } else {
            vc.sourceType = .photoLibrary
        }
        vc.delegate = self
        DispatchQueue.main.async {
            self.present(vc, animated: true)
        }
    }
    
    private func setImageInsideTextView(image: UIImage) {
        // create nsattachment
        let attachment = NSTextAttachment()
        let attrString = NSAttributedString(attachment: attachment)
        attachment.image = image
        // textview and image size
        let imageWidth = image.size.width
        let textview = noteView.textView
        let scaleFactor = imageWidth/(textview.frame.width-10)
        attachment.image = UIImage(cgImage: image.cgImage!, scale: scaleFactor, orientation: .up)
        // add image to textview
        textview.textStorage.insert(attrString, at: textview.selectedRange.location)
        textViewDidChange(noteView.textView)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    @objc func makeBold() {
        var text = noteView.textView.attributedText!
        let attribute = text.attribute(.font, at: 0, effectiveRange: nil) as! UIFont
        var newAttribute = [NSAttributedString.Key: Any]()
        if attribute.isBold {
            newAttribute = [.font: UIFont.systemFont(ofSize: 17)]
        } else {
            newAttribute = [.font: UIFont.boldSystemFont(ofSize: 17)]
        }
        let attrString = NSAttributedString(string: text.string, attributes: newAttribute)
        noteView.textView.attributedText = attrString
    }
    
    
    
}

extension EditController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let attributtedText = NSMutableAttributedString(attributedString: textView.attributedText)
        attributtedText.addAttribute(.font, value: UIFont.systemFont(ofSize: 17), range: NSRange(location: 0, length: attributtedText.length))
        textView.attributedText = attributtedText
        guard textView.attributedText != note.text else { return }
        note.text = textView.attributedText
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

extension EditController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        guard let image = info[.originalImage] as? UIImage else { return }
        setImageInsideTextView(image: image)
    }
}



