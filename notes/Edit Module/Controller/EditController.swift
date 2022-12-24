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
    
    var saveButton: SaveButton = {
        let button = SaveButton()
        button.setTitle("Done", for: .normal)
        button.setTitleColor(.blue, for: .normal)
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
        noteView.setSmallerFontTarget(target: self, action: #selector(smallerFontSize))
        noteView.setBiggerFontTarget(target: self, action: #selector(biggerFontSize))
    }
    
    private func setDelegates() {
        noteView.textView.delegate = self
    }
    
    private func photoPickerPresent(type: Resources.PhotoType) {
        let vc = UIImagePickerController()
        if type == .camera {
            vc.sourceType = .camera
        } else {
            vc.sourceType = .photoLibrary
        }
        vc.delegate = self
        present(vc, animated: true)
    }
    
    private func setImageInsideTextView(image: UIImage) {
        // create nsattachment
        let attachment = NSTextAttachment()
        let attrString = NSMutableAttributedString(attachment: attachment)
        attachment.image = image
        attrString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 17), range: NSRange(location: 0, length: attrString.length))
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
        DispatchQueue.main.async {
            self.saveButton.showLoading()
        }
        textViewDidEndEditing(noteView.textView)
        saveButton.hideLoading()
    }
    
    @objc func makeBold() {
        let range = noteView.textView.selectedRange
        var newAttribute = [NSAttributedString.Key: Any]()
        let string = NSMutableAttributedString(attributedString: noteView.textView.attributedText)
        let attribute = string.attribute(.font, at: range.location, longestEffectiveRange: nil, in: range) as! UIFont
        if attribute.isBold {
            newAttribute = [.font: UIFont.systemFont(ofSize: attribute.pointSize)]
        } else {
            newAttribute = [.font: UIFont.boldSystemFont(ofSize: attribute.pointSize)]
        }
        string.addAttributes(newAttribute, range: range)
        noteView.textView.attributedText = string
        textViewDidChange(noteView.textView)
        saveButton.hideLoading()
    }
    
    @objc func smallerFontSize() {
        let range = noteView.textView.selectedRange
        let string = NSMutableAttributedString(attributedString: noteView.textView.attributedText)
        let attribute = string.attribute(.font, at: range.location, longestEffectiveRange: nil, in: range) as! UIFont
        let newAttribute: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: attribute.pointSize-1)]
        string.addAttributes(newAttribute, range: range)
        noteView.textView.attributedText = string
        textViewDidChange(noteView.textView)
        saveButton.hideLoading()
    }
    
    @objc func biggerFontSize() {
        let range = noteView.textView.selectedRange
        let string = NSMutableAttributedString(attributedString: noteView.textView.attributedText)
        let attribute = string.attribute(.font, at: range.location, longestEffectiveRange: nil, in: range) as! UIFont
        let newAttribute: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: attribute.pointSize+1)]
        string.addAttributes(newAttribute, range: range)
        noteView.textView.attributedText = string
        textViewDidChange(noteView.textView)
        saveButton.hideLoading()
    }
    
}

extension EditController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
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



