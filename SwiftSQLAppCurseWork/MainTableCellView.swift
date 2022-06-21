//
//  MainTableCellView.swift
//  SwiftSQLAppCurseWork
//
//  Created by Gleb Sobolevsky on 20.06.2022.
//

import Cocoa

class MainTableCellView: NSTableCellView {
    
    weak var delegate: MainTableCellViewDelegate?
    
    @IBOutlet weak var cellTextField: NSTextField!

}

extension MainTableCellView: NSTextFieldDelegate {
    func controlTextDidEndEditing(_ obj: Notification) {
        print("controltext")
        delegate?.cellTextFieldHasChanged(self)
    }
}

protocol MainTableCellViewDelegate: AnyObject {
    func cellTextFieldHasChanged(_ cell: MainTableCellView)
}
