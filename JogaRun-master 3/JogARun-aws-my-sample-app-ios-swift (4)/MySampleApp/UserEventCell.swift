//
//  UserEventCell.swift
//  MySampleApp
//
//  Created by Matt Hibshman on 6/8/17.
//
//

import Foundation
import UIKit
class UserEventCell: UITableViewCell{
    
    @IBOutlet weak var location: UILabel!
    
    @IBOutlet weak var meetingPlace: UILabel!
    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var role: UILabel!
    
    @IBOutlet weak var endTime: UILabel!
    
    @IBOutlet weak var note: UITextView!
}
