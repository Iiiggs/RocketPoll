//
//  ParseTester.swift
//  ParseStarterProject
//
//  Created by Igor Kantor on 12/22/14.
//
//

//import Cocoa

class AccountViewController: PollingViewControllerBase, FBLoginViewDelegate {
    var parseUser: PFUser?

//    @IBOutlet weak var loginButton: FBLoginView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBAction func inviteFriends(sender: AnyObject) {}
    @IBOutlet weak var profilePictureImage: UIImageView!


    override func viewDidLoad() {
//        addParseUser()

        // add login button
        var loginButton = FBLoginView()
        loginButton.delegate = self
        self.view.addSubview(loginButton)

        loginButton.setTranslatesAutoresizingMaskIntoConstraints(false)

        self.view.addConstraint(NSLayoutConstraint(item: self.view, attribute: NSLayoutAttribute.Bottom, relatedBy:NSLayoutRelation.Equal, toItem: loginButton, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 20.0))

        self.view.addConstraint(NSLayoutConstraint(item: self.view, attribute: NSLayoutAttribute.CenterX, relatedBy:NSLayoutRelation.Equal, toItem: loginButton, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0.0))

    }

    func loginView(loginView: FBLoginView!, handleError error: NSError!) {

    }

    func loginViewShowingLoggedInUser(loginView: FBLoginView!) {

    }

    func loginViewShowingLoggedOutUser(loginView: FBLoginView!) {
        self.nameLabel.text = "Guest"
        self.profilePictureImage.image = nil
        self.parseUser = nil
        let appDelegate = UIApplication.sharedApplication().delegate! as PollingAppDelegate
        appDelegate.facebookUser = nil
    }

    func loginViewFetchedUserInfo(loginView: FBLoginView!, user: FBGraphUser!) {
        let appDelegate = UIApplication.sharedApplication().delegate! as PollingAppDelegate
        appDelegate.facebookUser = user

        // find out if user already exists


        // find some working examples of facebok/parse user management?
        // 

        if(self.parseUser == nil)
        {
            self.parseUser = PFUser()
            self.parseUser?.username = appDelegate.facebookUser?.name
            self.parseUser?.password = "rp123"

            self.parseUser?.signUpInBackgroundWithBlock { (succeded, error) -> Void in
                if succeded {
                    println("Success")
                }
                else {
                    println("Error: \(error)")

//                    self.parseUser? = PFUser.logInWithUsername(self.parseUser?.username, password: self.parseUser?.password)

                    PFUser.logInWithUsernameInBackground(self.parseUser?.username, password: self.parseUser?.password, block: { (parseUser, error) -> Void in
                        if error == nil {
                            println("Success Logging In")
                            

                            self.parseUser? = parseUser
                            self.parseUser?.setObject(user, forKey: "facebookUser")
                            self.parseUser?.save()
                        }
                        else {
                            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                                UIAlertView(title: "Error", message: error.description, delegate: nil, cancelButtonTitle: "OK").show()
                            })
                        }
                    })
                }
            }
        }


        self.nameLabel.text = user.name

        FBRequestConnection.startWithGraphPath("\(user.objectID)?fields=picture.type(large)", completionHandler: { (connection, result, error) -> Void in
            if error == nil{
                let jsonFeeds = result as FBGraphObject
                let picture = jsonFeeds.objectForKey("picture") as NSDictionary
                let data = picture.objectForKey("data") as NSDictionary
                let urlString = data.objectForKey("url") as NSString

                let url = NSURL(string:urlString)
                var err: NSError?
                var imageData = NSData(contentsOfURL:url!,options: NSDataReadingOptions.DataReadingMappedIfSafe, error: &err)

                if error == nil {
                    self.profilePictureImage.contentMode = UIViewContentMode.ScaleAspectFill
                    self.profilePictureImage.image = UIImage(data:imageData!)
                }
                else {
                    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                        UIAlertView(title: "Error", message: error.description, delegate: nil, cancelButtonTitle: "OK").show()
                    })
                }




//                self.profilePictureImage.image = result as UIImage
            }
            else {
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    UIAlertView(title: "Error", message: error.description, delegate: nil, cancelButtonTitle: "OK").show()
                })
            }

        })

    }



//    func addParseUser(){
//        var user = PFUser()
//        user.username = "Iiiggs2"
//        user.password = "abc123"
//        user.email = "igorkantor2@icloud.com"
//
//        user.setValue("913-608-2173", forKey: "phone")
//
//        user.signUpInBackgroundWithBlock { (succeded, error) -> Void in
//            if error == nil {
//                println("Success")
//            }
//            else {
//                println("Error: \(error)")
//            }
//        }
//
//    }
}
