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
    
    var text: NSAttributedString {
        guard let text = note.text else { return NSAttributedString(string: "")}
        let textWithFont = text.mutableCopy() as! NSMutableAttributedString
        textWithFont.addAttribute(.font, value: UIFont.systemFont(ofSize: 17), range: NSRange(location: 0, length: textWithFont.length))
        return textWithFont as NSAttributedString
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
