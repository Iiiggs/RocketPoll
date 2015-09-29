//
//  QuestionResultTableViewCell.swift
//  RocketPoll
//
//  Created by Igor Kantor on 2/4/15.
//
//

import UIKit

class QuestionResultTableViewCell: UITableViewCell {
    var constWidth: NSLayoutConstraint?
    var resultBar: UIView?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        self.resultBar = self.viewWithTag(1)!
        self.resultBar!.translatesAutoresizingMaskIntoConstraints = false

        self.constWidth = NSLayoutConstraint(item: self.resultBar!, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant:1)

        self.addConstraint(self.constWidth!)

//        self.contentView.layer.borderColor = UIColor.blackColor().CGColor
//        self.contentView.layer.borderWidth = 1.0
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
