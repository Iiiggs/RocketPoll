//
//  DataViewController.swift
//  SocialPolling
//
//  Created by Igor Kantor on 12/19/14.
//  Copyright (c) 2014 Igor Kantor. All rights reserved.
//

import UIKit
import CoreData

class PollingViewControllerBase: UIViewController, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate {
    var swipeShown = false

    var dataObject: AnyObject?

    override func viewDidLoad() {
        super.viewDidLoad()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

    }

    func presentLoginViewController(){
        if PFUser.currentUser() == nil{
            // login/signup view controller customization
            let login = RPLoginViewController()
            login.delegate = self
            login.fields = [PFLogInFields.UsernameAndPassword, PFLogInFields.LogInButton, PFLogInFields.SignUpButton, PFLogInFields.PasswordForgotten, PFLogInFields.Facebook, PFLogInFields.Twitter]
            self.presentViewController(login, animated: true) { () -> Void in
                login.signUpController = RPSignUpViewController()
                login.signUpController.delegate = self
            }
        }
    }


    // Login stuff
    func logInViewController(logInController: PFLogInViewController!, didLogInUser user: PFUser!) {
        // if we did a Facebook signin, grab some additional data
        // such as the username
        if PFFacebookUtils.isLinkedWithUser(user){
            var request = FBRequest.requestForMe()
            request.startWithCompletionHandler { (connection, fbUser, error) -> Void in
                if error == nil {
                    if (user.username != fbUser["name"] as? String){
                        user.username = fbUser["name"] as! String
                        user["gender"] = fbUser["gender"] as! String
                        user.saveEventually()
                    }
                }
                else {
                    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                        UIAlertView(title: "Error", message: error.description, delegate: nil, cancelButtonTitle: "OK").show()
                    })
                }
            }
        }
        else if PFTwitterUtils.isLinkedWithUser(user) // do the same with Twitter user login
        {
            let verify = NSURL(string: "https://api.twitter.com/1.1/account/verify_credentials.json")!
            let request = NSMutableURLRequest(URL: verify)
            PFTwitterUtils.twitter().signRequest(request)
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue(), completionHandler: { (response, data, error) -> Void in
                if error == nil {
                    let result = (try! NSJSONSerialization.JSONObjectWithData(data!, options: [])) as! NSDictionary
                    user.username = result["name"] as! String
                    user.saveEventually()
                }
                else {
                    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                        UIAlertView(title: "Error", message: error!.description, delegate: nil, cancelButtonTitle: "OK").show()
                    })
                }
            })
        }

        self.dismissViewControllerAnimated(true, completion: nil)
    }

    func logInViewController(logInController: PFLogInViewController!, didFailToLogInWithError error: NSError!) {
        UIAlertView(title: "Error", message: error.description, delegate: nil, cancelButtonTitle: "OK").show()
    }

    // Signup stuff
    func signUpViewController(signUpController: PFSignUpViewController!, didSignUpUser user: PFUser!) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    func signUpViewController(signUpController: PFSignUpViewController!, didFailToSignUpWithError error: NSError!) {
        UIAlertView(title: "Error", message: error.description, delegate: nil, cancelButtonTitle: "OK").show()
    }


    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
}

