//
//  RPLogin.swift
//  RocketPoll
//
//  Created by Igor Kantor on 1/24/15.
//
//

import UIKit

let rpColor = UIColor(red: 239.0/255.0, green: 239.0/255.0, blue: 244.0/255.0, alpha: 1.0)

class RPLoginViewController: PFLogInViewController {
    let logoView = UIImageView(image: UIImage(named: "Raccoon"))

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = rpColor

        self.logInView.logo = logoView

        PFFacebookUtils.initializeFacebook()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.logInView.logo.frame = CGRectMake(
            self.logInView.logo.frame.origin.x,
            self.logInView.logo.frame.origin.y - (175 - 57 - 20),
            175,
            175)
    }
}
