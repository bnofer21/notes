//
//  EditViewController.swift
//  notes
//
//  Created by Юрий on 28.02.2023.
//

import UIKit
import AVFoundation

final class EditViewController: UIViewController {
    
    var viewmodel: EditViewModelProtocol? {
        didSet {
            configureView()
        }
    }
    
    var isImageAdded = false
    
    var cameraButton: UIButton = {
       let butt = UIButton()
        let conf = UIImage.SymbolConfiguration(pointSize: 25, weight: .regular, scale: .large)
        butt.setImage(UIImage(systemName: "camera", withConfiguration: conf), for: .normal)
        return butt
    }()
    
    var doneButton: UIButton = {
        let but = UIButton(type: .system)
        but.setTitle("Done", for: .normal)
        return but
    }()
    
    var editView = EditNoteView()
    
    override func loadView() {
        view = editView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBarTargets()
        delegates()
        setupView()
        setKeyboardObserver()
    }
    
    private func configureView() {
        guard let viewmodel = viewmodel else { return }
        editView.viewModel = viewmodel
    }
    
    private func setupView() {
        doneButton.addTarget(self, action: #selector(hideKeyboard), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: doneButton)
        configureToolBar()
    }
    
    private func delegates() {
        editView.textView.delegate = self
    }
    
    private func show(_ error: String) {
        DispatchQueue.main.async { [weak self] in
            let alertController = UIAlertController()
            alertController.title = "Error"
            alertController.message = error
            
            let ok = UIAlertAction(title: "OK", style: .cancel)
            alertController.addAction(ok)
            
            self?.present(alertController, animated: true)
        }
    }
    
    private func showImagePicker(type: Resources.PhotoType) {
        if UIImagePickerController.isSourceTypeAvailable(type == .camera ? .camera : .photoLibrary) {
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = type == .camera ? .camera : .photoLibrary
            self.present(picker, animated: true)
        }
    }
    
    private func configureToolBar() {
        let pictureAction = UIBarButtonItem(customView: cameraButton)
        
        let imageFromCamera = UIAction(title: "Camera", image: UIImage(systemName: "camera")) { [weak self] _ in
            self?.showImagePicker(type: .camera)
        }
        let imageFromGallery = UIAction(title: "From gallery", image: UIImage(systemName: "photo.on.rectangle")) { [weak self] _ in
            self?.showImagePicker(type: .gallery)
        }
        cameraButton.menu = UIMenu(title: "", children: [imageFromCamera, imageFromGallery])
        cameraButton.showsMenuAsPrimaryAction = true
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolbarItems = [space, pictureAction, space]
        
    }
    
    private func setKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    private func setBarTargets() {
        editView.setBarTargets(target: self, action: #selector(barEventOccured(_:)))
    }
    
    private func moveViewWithKeyboard(notification: NSNotification, viewBottomConstraint: NSLayoutConstraint, keyboardWillShow: Bool) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        let keyboardHeight = keyboardSize.height
        
        let keyboardDuration = notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        let keyboardCurve = UIView.AnimationCurve(rawValue: notification.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as! Int)!
        
        if keyboardWillShow {
            let safeAreaExists = (self.editView.window?.safeAreaInsets.bottom != 0)
            let bottomConst: CGFloat = 30
            
            editView.bottomConstraint.constant = -(keyboardHeight + (safeAreaExists ? 0 : bottomConst))
        } else {
            viewBottomConstraint.constant = 30
        }
        
        let animator = UIViewPropertyAnimator(duration: keyboardDuration, curve: keyboardCurve) { [weak self] in
            self?.editView.layoutIfNeeded()
        }
        
        animator.startAnimation()
    }
    
    private func addImage(_ image: UIImage) {
        // create nsattachment
        let attachment = NSTextAttachment()
        let attrString = NSMutableAttributedString(attachment: attachment)
        attachment.image = image
        attrString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 17), range: NSRange(location: 0, length: attrString.length))
        // textview and image size
        let imageWidth = image.size.width
        let textview = editView.textView
        let scaleFactor = imageWidth/textview.frame.width
        let newImg = UIImage(cgImage: image.cgImage!, scale: scaleFactor, orientation: image.imageOrientation)
        attachment.image = newImg
        // add image to textview
        textview.textStorage.insert(attrString, at: textview.selectedRange.location)
        isImageAdded = true
    }
    
    @objc private func barEventOccured(_ sender: UIButton) {
        guard editView.textView.selectedRange.length > 0 else { return }
        viewmodel?.changeAttributes(type: sender.tag, range: editView.textView.selectedRange, completion: { [weak self] error in
            if let error = error {
                self?.show(error)
            } else {
                self?.configureView()
            }
        })
    }
    
    @objc private func hideKeyboard() {
        editView.endEditing(true)
    }
    
    @objc private func keyboardWillShow(_ notification: NSNotification) {
        if editView.textView.isFirstResponder {
            moveViewWithKeyboard(notification: notification, viewBottomConstraint: editView.bottomConstraint, keyboardWillShow: true)
        }
    }
    
    @objc private func keyboardWillHide(_ notification: NSNotification) {
        moveViewWithKeyboard(notification: notification, viewBottomConstraint: editView.bottomConstraint, keyboardWillShow: false)
    }
    
}

extension EditViewController: UITextViewDelegate {
    
    func textViewDidEndEditing(_ textView: UITextView) {
        guard let viewmodel = viewmodel, viewmodel.text != textView.attributedText || viewmodel.attributesChanged || isImageAdded else { return }
            viewmodel.saveNote(text: textView.attributedText) { [weak self] error in
                if let error = error {
                    self?.show(error)
                } else {
                    self?.isImageAdded = false
                }
        }
    }
}

extension EditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        addImage(image)
        self.dismiss(animated: true)
    }
}
