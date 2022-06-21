//
//  DBManager.swift
//  SwiftSQLAppCurseWork
//
//  Created by Gleb Sobolevsky on 20.06.2022.
//

import Foundation

class DBManager {
    
    func createEvent(event: Event, complitionHandler: (()->())? = nil)
    {
        let requestURL = URL(string: DBURLs.URL_INSERT_EVENT.rawValue)
        var request = URLRequest(url: requestURL!)
        
        request.httpMethod = "POST"
        
        let startDate = DateUtilities.DateToSQLString(date: event.StartDate)
        let endDate =  DateUtilities.DateToSQLString(date: event.EndDate)

        let postParameters = "name="+event.Name+"&place="+event.Place+"&startDate="+startDate+"&endDate="+endDate;

        request.httpBody = postParameters.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if error != nil{
                print("error is \(error.debugDescription)")
                return;
            }
        
            do {
                let myJSON = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                
                if let parseJSON = myJSON {
                    var msg : String!
                    msg = parseJSON["message"] as! String?
                    print(msg!)
                }
            } catch {
                print("task error \(error)")
            }
            
            if let complition = complitionHandler {
                complition()
            }
        }

        task.resume()
    }
    
    func updateEvent(event: Event, complitionHandler: (()->())? = nil)
    {
        let requestURL = URL(string: DBURLs.URL_UPDATE_EVENT.rawValue)
        var request = URLRequest(url: requestURL!)
        
        request.httpMethod = "POST"
        
        let startDate = DateUtilities.DateToSQLString(date: event.StartDate)
        let endDate =  DateUtilities.DateToSQLString(date: event.EndDate)
        
        let postParameters = "id="+String(event.ID ?? 0)+"&name="+event.Name+"&place="+event.Place+"&startDate="+startDate+"&endDate="+endDate;
        request.httpBody = postParameters.data(using: .utf8)

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if error != nil{
                print("error is \(error.debugDescription)")
                return;
            }
        
            do {
                let myJSON = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                
                if let parseJSON = myJSON {
                    var msg : String!
                    msg = parseJSON["message"] as! String?
                    print(msg!)
                }
            } catch {
                print("task error \(error)")
            }
            
            if let complition = complitionHandler {
                complition()
            }
        }

        task.resume()
    }
    
    func fetchEvents(complitionHandler: ([Event])->()) {
        let url = URL(string: DBURLs.URL_GET_EVENT.rawValue)!
        let data = try? Data(contentsOf: url)

        do {
            let events = try JSONDecoder().decode([Event].self, from: data!)
            complitionHandler(events)
        } catch {
            print(error)
        }
    }
    
    func deleteEvent(event: Event, complitionHandler: (()->())? = nil) {
        let requestURL = URL(string: DBURLs.URL_DELETE_EVENT.rawValue)
        var request = URLRequest(url: requestURL!)
        
        request.httpMethod = "POST"

        let postParameters = "id="+String(event.ID ?? -1)
        
        request.httpBody = postParameters.data(using: .utf8)

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if error != nil{
                print("error is \(error.debugDescription)")
                return;
            }
        
            do {
                let myJSON = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                
                if let parseJSON = myJSON {
                    var msg : String!
                    msg = parseJSON["message"] as! String?
                    print(msg!)
                }
            } catch {
                print("task error \(error)")
            }
            
            if let complition = complitionHandler {
                complition()
            }
        }

        task.resume()
    }
}

struct Event: Codable {
    var ID: Int?
    var Name: String
    var Place: String
    var StartDate: Date?
    var EndDate: Date?
    
    static var base: Event {
        return Event(id: nil, name: "Name", place: "Place", startDate: Date.now, endDate: Date.now)
    }
    
    enum CodingKeys: String, CodingKey {
        case ID
        case Name
        case Place
        case StartDate
        case EndDate
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(String(ID ?? 0), forKey: .ID)
        try container.encode(Name, forKey: .Name)
        try container.encode(Place, forKey: .Place)
        
        try container.encode(DateUtilities.DateToSQLString(date: StartDate), forKey: .StartDate)
        try container.encode(DateUtilities.DateToSQLString(date: EndDate), forKey: .EndDate)
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        ID = Int(try container.decode(String.self, forKey: .ID))
        Name = try container.decode(String.self, forKey: .Name)
        Place = try container.decode(String.self, forKey: .Place)
        
        StartDate = DateUtilities.SQLDateStringToDate(strDate: try container.decode(String.self, forKey: .StartDate))
        EndDate = DateUtilities.SQLDateStringToDate(strDate: try container.decode(String.self, forKey: .EndDate))
    }
    init(id: Int?, name: String, place: String, startDate: Date, endDate: Date) {
        ID = id
        Name = name
        Place = place
        StartDate = startDate
        EndDate = endDate
    }
}

fileprivate enum DBURLs: String {
    case URL_INSERT_EVENT = "http://192.168.64.2/CurseWorkAPI/api/CreateEvent.php?"
    case URL_UPDATE_EVENT = "http://192.168.64.2/CurseWorkAPI/api/UpdateEvent.php?"
    case URL_GET_EVENT = "http://192.168.64.2/CurseWorkAPI/api/GetEvents.php"
    case URL_DELETE_EVENT = "http://192.168.64.2/CurseWorkAPI/api/DeleteEvent.php?"
}
