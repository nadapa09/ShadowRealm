//
//  CreateLog.swift
//  MySampleApp
//
//  Created by Thomas Gales on 4/7/17.
//
//

import UIKit
import Foundation
import AWSMobileHubHelper
import AWSDynamoDB

class CreateLog:UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var date: UITextField!
    @IBOutlet weak var start: UITextField!
    @IBOutlet weak var end: UITextField!
    @IBOutlet weak var meeting: UITextField!
    @IBOutlet weak var availability: UITextField!
    @IBOutlet weak var role: UITextField!
    @IBOutlet weak var descriptionField: UITextView!
    @IBOutlet weak var nameField: UITextField!
   
    
    fileprivate let homeButton: UIBarButtonItem = UIBarButtonItem(title: nil, style: .done, target: nil, action: nil)
    
    var logInfo: [Events] = []
    var add: Bool = false
    var dateString: String = ""
    var myShoes: [Shoes] = []
    var wait = true
    var selectedShoe: Shoes = Shoes()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(dateString != ""){
            date.text = dateString
        }
        
        navigationController?.delegate = self
        navigationItem.rightBarButtonItem = homeButton
        navigationItem.rightBarButtonItem!.target = self
        navigationItem.rightBarButtonItem!.title = NSLocalizedString("Home", comment: "")
        navigationItem.rightBarButtonItem!.action = #selector(self.goBackHome)
        navigationController?.delegate = self
        
    }
    
    
func goBackHome() {
    navigationController?.popToRootViewController(animated: true)
}



    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if(add){
            (viewController as? ViewIndivLog)?.logInfo.logStuff = logInfo // Here you pass the to your original view controller
        }
    }
    
   
    
    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        let objectMapper = AWSDynamoDBObjectMapper.default()
//        
//        let itemToCreate: Shoes = Shoes()
//        
//        itemToCreate._userId = AWSIdentityManager.default().identityId!
//        itemToCreate._shoe = textField.text
//        for s in myShoes{
//            if s._shoe == itemToCreate._shoe{
//                UIAlertView(title: "Shoe already exists",
//                            message: "",
//                            delegate: nil,
//                            cancelButtonTitle: "Ok").show()
//                return true
//            }
//        }
//        itemToCreate._mileage = 0.0
//        objectMapper.save(itemToCreate, completionHandler: {(error: Error?) -> Void in
//            if let error = error {
//                print("Amazon DynamoDB Save Error: \(error)")
//                return
//            }
//            print("Item saved.")
//            DispatchQueue.main.async {
//                self.loadShoes()
//            }
//        })
//        return true
//    }
    
   
    
    @IBAction func submit(_ sender: UIButton) {
//        if shoe.text == "Shoe:\n[None]" {
//            UIAlertView(title: "Please select a shoe",
//                        message: "Please select above",
//                        delegate: nil,
//                        cancelButtonTitle: "Ok").show()
//            return
//        }
//        
//        //CHECK FIELDS
//        let dateRegex = "^\\d{1,2}\\/\\d{1,2}\\/\\d{4}$"
//        var regex = try! NSRegularExpression(pattern:dateRegex,options:[])
//        var matches = regex.matches(in: date.text!, options: [], range: NSRange(location: 0, length: date.text!.characters.count))
//        if(matches.isEmpty){
//            UIAlertView(title: "Error: invalid Date",
//                        message: "must be in form MM/DD/YYYY",
//                        delegate: nil,
//                        cancelButtonTitle: "Ok").show()
//            return
//        }
//        let milesRegex = "[\\d]+[.]?[\\d]{0,2}"
//        regex = try! NSRegularExpression(pattern:milesRegex,options:[])
//        matches = regex.matches(in: miles.text!, options: [], range: NSRange(location: 0, length: miles.text!.characters.count))
//        if(matches.isEmpty || matches.map{ (miles.text! as NSString).substring(with: $0.range) }[0] != miles.text!){
//            UIAlertView(title: "Error: invalid Miles",
//                        message: "must be number with maximum two decimal places",
//                        delegate: nil,
//                        cancelButtonTitle: "Ok").show()
//            return
//        }
//        let timeRegex = "[\\d]+[:][\\d]{2}"
//        regex = try! NSRegularExpression(pattern:timeRegex,options:[])
//        matches = regex.matches(in: time.text!, options: [], range: NSRange(location: 0, length: time.text!.characters.count))
//        if(matches.isEmpty || matches.map{ (time.text! as NSString).substring(with: $0.range) }[0] != time.text!){
//            UIAlertView(title: "Error: invalid Time",
//                        message: "must be of form min:sec",
//                        delegate: nil,
//                        cancelButtonTitle: "Ok").show()
//            return
//        }
        //NnavigationController?.popViewController(animated: true)
        insertData()
    }
    
    func insertData() {
        let objectMapper = AWSDynamoDBObjectMapper.default()
        
        let itemToCreate: Events = Events()
        
        
        
        
        
//        if(date.text?.characters.count == 9 || date.text?.characters.count == 8){
//            date.text = "0" + date.text!
//        }
        itemToCreate._location = location.text
        itemToCreate._date = date.text
        itemToCreate._description = descriptionField.text
        itemToCreate._endTime = end.text
        itemToCreate._meetingPlace = meeting.text
        itemToCreate._name = nameField.text
        itemToCreate._remainingCapacity = Double(availability.text!)! as NSNumber?
        itemToCreate._role = role.text
        itemToCreate._startTime = start.text
        itemToCreate._timestamp = NSNumber(value: Date().timeIntervalSince1970)
        
        
       
        
        objectMapper.save(itemToCreate, completionHandler: {(error: Error?) -> Void in
            if let error = error {
                print("Amazon DynamoDB Save Error: \(error)")
                return
            }
            print("Item saved.")
            
            
        })
        
        let itemToCreate2: CreatedEvents = CreatedEvents()
        
        
        
        
        
        //        if(date.text?.characters.count == 9 || date.text?.characters.count == 8){
        //            date.text = "0" + date.text!
        //        }
        itemToCreate2._location = location.text
        itemToCreate2._date = date.text
        itemToCreate2._description = descriptionField.text
        itemToCreate2._endTime = end.text
        itemToCreate2._meetingPlace = meeting.text
        itemToCreate2._name = AWSIdentityManager.default().identityId!
        itemToCreate2._remainingCapacity = availability.text
        itemToCreate2._role = role.text
        itemToCreate2._startTime = start.text
        itemToCreate2._timestamp = String(describing: Date().timeIntervalSince1970)
        itemToCreate2._userId = AWSIdentityManager.default().identityId!
        
        
        
        
        objectMapper.save(itemToCreate2, completionHandler: {(error: Error?) -> Void in
            if let error = error {
                print("Amazon DynamoDB Save Error: \(error)")
                return
            }
            print("Item saved.")
            
            
        })
        
        let alert = UIAlertController(title: "Success", message: "", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        logInfo.append(itemToCreate)
        print(logInfo)
//        updateShoes()
        
    }


}
