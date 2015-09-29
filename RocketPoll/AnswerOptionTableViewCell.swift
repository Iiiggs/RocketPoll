//
//  AnswerOptionTableViewCell.swift
//  SocialPolling
//
//  Created by Igor Kantor on 12/19/14.
//  Copyright (c) 2014 Igor Kantor. All rights reserved.
//

import UIKit

class AnswerOptionTableViewCell: UITableViewCell {
    @IBOutlet weak var answerLabel: UILabel!

    @IBOutlet weak var answerOptionLabel: UILabel!

    @IBOutlet weak var optionSelectionView: CircleView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
