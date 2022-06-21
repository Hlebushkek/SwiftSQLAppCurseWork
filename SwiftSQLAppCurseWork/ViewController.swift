//
//  ViewController.swift
//  SwiftSQLAppCurseWork
//
//  Created by Gleb Sobolevsky on 20.06.2022.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var tableView: NSTableView!
    
    var events: [Event] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    let dbManager = DBManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        dbManager.fetchEvents { events in
            self.events = events
        }
    }

    @IBAction func createNewEvent(_ sender: Any) {
        dbManager.createEvent(event: Event.base) {
            self.dbManager.fetchEvents { events in
                DispatchQueue.main.async {
                    self.events = events
                }
            }
        }
    }
}

extension ViewController: NSTableViewDelegate, NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        guard let column = tableColumn else { return NSTableCellView() }
        
        if column.identifier.rawValue == "actions" {
            guard let actionsCell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "actionsCell"), owner: self) as? ActionsTableCellView else { return NSTableCellView() }
            actionsCell.delegate = self
            
            return actionsCell
        } else {
            guard let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "textCell"), owner: self) as? MainTableCellView else { return NSTableCellView() }
            cell.cellTextField.delegate = cell
            cell.delegate = self
            
            switch column.identifier.rawValue {
            case "id":
                cell.cellTextField.stringValue = String(events[row].ID ?? -1)
            case "name":
                cell.cellTextField.stringValue = events[row].Name
            case "place":
                cell.cellTextField.stringValue = events[row].Place
            case "startdate":
                cell.cellTextField.stringValue = DateUtilities.DateToSQLString(date: events[row].StartDate)
            case "enddate":
                cell.cellTextField.stringValue = DateUtilities.DateToSQLString(date: events[row].EndDate)
            default:
                break
            }
            
            return cell
        }
    }
}

extension ViewController: ActionsTableCellViewDelegate {
    func updateEvent(cell: NSTableCellView) {
        let rowIndex = tableView.row(for: cell)
        print(rowIndex)
        
        dbManager.updateEvent(event: events[rowIndex])
    }
    
    func deleteEvent(cell: NSTableCellView) {
        let rowIndex = tableView.row(for: cell)
        print(rowIndex)
        
        dbManager.deleteEvent(event: events[rowIndex])
        events.remove(at: rowIndex)
    }
}

extension ViewController: MainTableCellViewDelegate {
    func cellTextFieldHasChanged(_ cell: MainTableCellView) {
        let rowIndex = tableView.row(for: cell)
        let columnIndex = tableView.column(for: cell)
        guard rowIndex >= 0 && columnIndex >= 0 else { return }
        print(rowIndex)
        switch columnIndex {
        case 1:
            events[rowIndex].Name = cell.cellTextField.stringValue
            print(events[rowIndex].Name)
        case 2:
            events[rowIndex].Place = cell.cellTextField.stringValue
        case 3:
            events[rowIndex].StartDate = DateUtilities.SQLDateStringToDate(strDate: cell.cellTextField.stringValue)
        case 4:
            events[rowIndex].EndDate = DateUtilities.SQLDateStringToDate(strDate: cell.cellTextField.stringValue)
        default:
            break
        }
    }
}
