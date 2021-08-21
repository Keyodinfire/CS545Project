//
//  ViewController.swift
//  WorkMoreApp
//
//  Created by user201634 on 7/23/21.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {
    
    @IBOutlet var table: UITableView!
    
    var models = [WorkMoreReminder] ()

    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
    }
    
    @IBAction func addReminder() {
        guard let vc = storyboard?.instantiateViewController(identifier: "add") as? AddViewController else {
            return
        }
        
        vc.title = "New Reminder"
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.completion = { title, body, reminderDateStart, reminderDateEnd, reminderBreak, reminderBreakEnd in
            DispatchQueue.main.async {
                self.navigationController?.popToRootViewController(animated: true)
                let newReminder = WorkMoreReminder(title: title, startDate: reminderDateStart, endDate: reminderDateEnd, breakTime: reminderBreak, breakTimeEnd: reminderBreakEnd, identifier: "id_\(title)")
                self.models.append(newReminder)
                self.table.reloadData()
                
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: { success, error in
                    if success {
                        let center = UNUserNotificationCenter.current()
                        
                        let content = UNMutableNotificationContent()
                        content.title = title
                        content.sound = .default
                        content.body = body
                                        
                        let targetDate = newReminder.startDate
                        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: targetDate), repeats: false)
                                        
                        let request = UNNotificationRequest(identifier: "notification_id", content: content, trigger: trigger)
                        center.add(request, withCompletionHandler: { error in
                                if error != nil {
                                    print("An error has occurred. ")
                                    }
                            })
                        
                        let breakContent = UNMutableNotificationContent()
                        breakContent.title = title
                        breakContent.sound = .default
                        breakContent.body = "Break Time!"
                        
                        let targetBreakDate = newReminder.breakTime
                        let breakTrigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: targetBreakDate), repeats: false)
                        let breakRequest = UNNotificationRequest(identifier: "break_id", content: breakContent, trigger: breakTrigger)
                        center.add(breakRequest, withCompletionHandler: { error in
                                if error != nil {
                                    print("An error has occurred. ")
                                    }
                            })
                        
                        let breakEndContent = UNMutableNotificationContent()
                        breakEndContent.title = title
                        breakEndContent.sound = .default
                        breakEndContent.body = "Break Time is Over!"
                        
                        let targetBreakEndDate = newReminder.breakTimeEnd
                        let breakEndTrigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: targetBreakEndDate), repeats: false)
                        let breakEndRequest = UNNotificationRequest(identifier: "break_end_id", content: breakEndContent, trigger: breakEndTrigger)
                        center.add(breakEndRequest, withCompletionHandler: { error in
                                if error != nil {
                                    print("An error has occurred. ")
                                    }
                            })
                        
                        let endContent = UNMutableNotificationContent()
                        endContent.title = title
                        endContent.sound = .default
                        endContent.body = "Good work! You're done!"
                        
                        let targetEnd = newReminder.endDate
                        let endTrigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: targetEnd), repeats: false)
                        let endRequest = UNNotificationRequest(identifier: "end_id", content: endContent, trigger: endTrigger)
                        center.add(endRequest, withCompletionHandler: { error in
                                if error != nil {
                                    print("An error has occurred. ")
                                    }
                            })
                        
                    }
                    else if error != nil{
                        print("Error. Please try again.")
                    }
                })
                
                
            }
        }
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    


}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}


extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = models[indexPath.row].title
        let startDate = models[indexPath.row].startDate
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, YYYY h:mm a"
        cell.detailTextLabel?.text = formatter.string(from: startDate)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            models.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
}


struct WorkMoreReminder {
    let title: String
    let startDate: Date
    let endDate: Date
    let breakTime: Date
    let breakTimeEnd: Date
    let identifier: String
}
