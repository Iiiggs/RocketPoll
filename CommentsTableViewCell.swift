//
//  CommentsTableViewCell.swift
//  RocketPoll
//
//  Created by Igor Kantor on 3/14/15.
//
//

import UIKit

class CommentsTableViewCell: UITableViewCell {


    @IBOutlet weak var profilePictureImageView: UIImageView!

    @IBOutlet weak var commentTextLabel: UILabel!

    @IBOutlet weak var byTextLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
