//
//  FriendTableViewCell.swift
//  RocketPoll
//
//  Created by Igor Kantor on 4/2/15.
//
//

import UIKit

class FriendTableViewCell: UITableViewCell {

    @IBOutlet weak var profilePictureImageView: UIImageView!

    @IBOutlet weak var nameLabel: UILabel!

    override func setHighlighted(highlighted: Bool, animated: Bool) {
        if(highlighted){
            self.accessoryType = .Checkmark
        }
        else {
            self.accessoryType = .None
        }
    }
}
