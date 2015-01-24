//
//  RPSignUpViewController.swift
//  RocketPoll
//
//  Created by Igor Kantor on 1/24/15.
//
//

import UIKit

class RPSignUpViewController: PFSignUpViewController {
    let logoView = UIImageView(image: UIImage(named: "Rocket"))

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = rpColor

        self.signUpView.logo = logoView
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.signUpView.logo.frame = CGRectMake(
            self.signUpView.logo.frame.origin.x,
            self.signUpView.logo.frame.origin.y - (175 - 57 - 20),
            175,
            175)
    }

}
