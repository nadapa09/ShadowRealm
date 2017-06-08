//
//  ViewTeam.swift
//  MySampleApp
//
//  Created by Thomas Gales on 4/21/17.
//
//

import Foundation
import UIKit
import AWSMobileHubHelper
import AWSDynamoDB

class ViewTeam: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var teams: [SignUp] = []
    var team: String = ""
    var wait: Bool = true
    @IBOutlet weak var teamList: UITableView!
    fileprivate let homeButton: UIBarButtonItem = UIBarButtonItem(title: nil, style: .done, target: nil, action: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dbQuery()
        teamList.dataSource = self
        teamList.delegate = self
        // Do any additional setup after loading the view.
        navigationItem.rightBarButtonItem = homeButton
        navigationItem.rightBarButtonItem!.target = self
        navigationItem.rightBarButtonItem!.title = NSLocalizedString("Home", comment: "")
        navigationItem.rightBarButtonItem!.action = #selector(self.goBackHome)
    }

func goBackHome() {
    navigationController?.popToRootViewController(animated: true)
}

    override func viewDidAppear(_ animated: Bool) {
        
        dbQuery()
        teamList.dataSource = self
        teamList.delegate = self
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as!UserEventCell
        cell.location.text = "Location: " + teams[indexPath.row]._location!
        cell.meetingPlace.text = "Meeting Place: " + teams[indexPath.row]._meetingPlace!
        cell.startTime.text = "Start Time: " + teams[indexPath.row]._startTime!
        cell.role.text = "Role: " + teams[indexPath.row]._role!
        cell.endTime.text = "End Time: " + teams[indexPath.row]._endTime!
        cell.note.text = teams[indexPath.row]._description
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(teams.count)
        return teams.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(teams[indexPath.row])
//        let storyboard = UIStoryboard(name: "ViewLog", bundle: nil)
//        let controller = storyboard.instantiateViewController(withIdentifier: "ViewLog") as! ViewLog
//        if(teams[indexPath.row]._userId! != AWSIdentityManager.default().identityId!){
//            controller.myLog = false
//            controller.uId = teams[indexPath.row]._userId!
//        }
//        
//        navigationController?.pushViewController(controller, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAtindexPath: IndexPath){
        
    }
    
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCellEditingStyle,
                   forRowAt indexPath: IndexPath){
//        let alertController = UIAlertController(title: "Remove user from " + self.team + "?", message: "", preferredStyle: .alert)
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
//            // ...
//        }
//        alertController.addAction(cancelAction)
//        
//        let OKAction = UIAlertAction(title: "OK", style: .default) { action in
//            let objectMapper = AWSDynamoDBObjectMapper.default()
//            let item = Teams()
//            item?._team = self.team
//            item?._userId = self.teams[indexPath.row]._userId
// 
//            self.wait = true
//            objectMapper.remove(item!, completionHandler: {(error: Error?) in
//                                   DispatchQueue.main.async(execute: {
//                                    
//                                    })
//                                })
//            self.teams.remove(at: indexPath.row)
//            tableView.reloadData()
//
//        }
//        alertController.addAction(OKAction)
//        self.present(alertController, animated: true) {
//            // ...
//        }
//        return
    }
    
    func dbQuery() {
        teams.removeAll()
        let objectMapper = AWSDynamoDBObjectMapper.default()
        let scanExpression = AWSDynamoDBScanExpression()
        scanExpression.filterExpression = "#userId = :userId"
        scanExpression.expressionAttributeNames = ["#userId": "userId",]
        scanExpression.expressionAttributeValues = [":userId":AWSIdentityManager.default().identityId!,]
        wait = true
        objectMapper.scan(SignUp.self, expression: scanExpression).continueWith(block: { (task:AWSTask<AWSDynamoDBPaginatedOutput>!) -> Any? in
            if let error = task.error as? NSError {
                print("The request failed. Error: \(error)")
            } else if let paginatedOutput = task.result {
                for team in paginatedOutput.items as! [SignUp] {
                    self.teams.append(team)
                    
                }
                
                self.wait = false
                self.teamList.reloadData()
            }
            return nil
        })
    }
    
}
