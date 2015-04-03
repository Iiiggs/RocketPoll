//
//  FriendTableViewCell.swift
//  RocketPoll
//
//  Created by Igor Kantor on 4/2/15.
//
//

import UIKit

class FriendTableViewCell: UITableViewCell {

    override func setHighlighted(highlighted: Bool, animated: Bool) {
        if(highlighted){
            self.accessoryType = .Checkmark
        }
        else {
            self.accessoryType = .None
        }
    }
}
