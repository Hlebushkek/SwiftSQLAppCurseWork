//
//  ActionsTableCellView.swift
//  SwiftSQLAppCurseWork
//
//  Created by Gleb Sobolevsky on 21.06.2022.
//

import Cocoa

class ActionsTableCellView: NSTableCellView {
    @IBOutlet weak var updateButton: NSButton!
    @IBOutlet weak var deleteButton: NSButton!
    
    weak var delegate: ActionsTableCellViewDelegate?
    
    @IBAction func updateButtonWasPressed(_ sender: Any) {
        delegate?.updateEvent(cell: self)
    }
    
    @IBAction func deleteActionWasPressed(_ sender: Any) {
        delegate?.deleteEvent(cell: self)
    }
}

protocol ActionsTableCellViewDelegate: AnyObject {
    func updateEvent(cell: NSTableCellView)
    func deleteEvent(cell: NSTableCellView)
}
