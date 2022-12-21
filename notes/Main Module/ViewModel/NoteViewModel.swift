//
//  NoteViewModel.swift
//  notes
//
//  Created by Юрий on 21.12.2022.
//

import UIKit

struct NoteViewModel {
    
    var note: Note
    
    var name: String {
        guard let name = note.name else { return ""}
        return name
    }
    
    var text: String {
        guard let text = note.text else { return ""}
        return text
    }
    
    var image: UIImage {
        guard let data = note.image, let img = UIImage(data: data) else { return UIImage()}
        return img
    }
    
    init(note: Note) {
        self.note = note
    }
}
