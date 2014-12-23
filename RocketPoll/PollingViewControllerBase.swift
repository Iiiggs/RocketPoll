//
//  DataViewController.swift
//  SocialPolling
//
//  Created by Igor Kantor on 12/19/14.
//  Copyright (c) 2014 Igor Kantor. All rights reserved.
//

import UIKit
import CoreData

class PollingViewControllerBase: UIViewController {
    var swipeShown = false

    var dataObject: AnyObject?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        setupManagedObjectContext()

        var question = [NSManagedObject]()



    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewWillDisappear(animated: Bool) {
        let swipeImageView = self.view.viewWithTag(50)?

        if swipeImageView != nil {
            UIView.animateWithDuration(0.5, animations: {
                    swipeImageView!.alpha = 0.0
                }) { (Bool) -> Void in
                    swipeImageView!.removeFromSuperview()
                    self.swipeShown = false
            }
        }
    }

    func showSwipeRight()
    {

        if !swipeShown{
            swipeShown = true

            var image = UIImage(named: "swipe_right.png")
            var imageView = UIImageView(image: image)
            imageView.contentMode = UIViewContentMode.ScaleToFill
            imageView.alpha = 0.0
            imageView.tag = 50
            self.view.addSubview(imageView)

            UIView.animateWithDuration(0.5, animations: {
                    imageView.alpha = 0.2
                }) { (Bool) -> Void in
            }


        }
    }
}

