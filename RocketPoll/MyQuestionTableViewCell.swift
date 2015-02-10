//
//  MyQuestionTableViewCell.swift
//  RocketPoll
//
//  Created by Igor Kantor on 1/24/15.
//
//

import UIKit

class MyQuestionTableViewCell: UITableViewCell {

    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet weak var responseCount: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
