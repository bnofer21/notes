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
    
    var date: String {
        guard let date = note.date else { return "9 Jan 9:41"}
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM HH:mm"
        return formatter.string(from: date)
    }
    
    init(note: Note) {
        self.note = note
    }
}
