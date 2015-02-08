//
//  ParseTester.swift
//  ParseStarterProject
//
//  Created by Igor Kantor on 12/22/14.
//
//

//import Cocoa

class AccountViewController: PollingViewControllerBase, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

//    @IBOutlet weak var loginButton: FBLoginView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profilePictureImage: UIImageView!
    @IBOutlet weak var questionsCreatedLabel: UILabel!
    @IBOutlet weak var questionsAnsweredLabel: UILabel!

    @IBOutlet weak var login: UIButton!

    @IBOutlet weak var uploadProfilePictureButton: UIButton!

    @IBOutlet weak var pageControl: UIPageControl!


    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateLabels()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        updateLabels()
    }


    func updateLabels(){
        if PFUser.currentUser() != nil{
            self.nameLabel.text = PFUser.currentUser().username
            self.login.setTitle("Logout", forState: UIControlState.Normal)
            self.profilePictureImage.hidden = false
            self.questionsAnsweredLabel.hidden = false
            self.questionsCreatedLabel.hidden = false
            self.uploadProfilePictureButton.hidden = false

            if PFUser.currentUser().objectForKey("profile_picture") != nil {
                let profilePictureFile = PFUser.currentUser().objectForKey("profile_picture") as PFFile
                profilePictureFile.getDataInBackgroundWithBlock({ (profilePicData, error) -> Void in
                    if error == nil {
                        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                            self.profilePictureImage.image = UIImage(data: profilePicData)
                        })
                    }
                    else {
                        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                            UIAlertView(title: "Error", message: error.description, delegate: nil, cancelButtonTitle: "OK").show()
                        })
                    }
                })

            }

            // count questions asked
            var questionsCountQuery = PFQuery(className: "Question")
            questionsCountQuery.whereKey("askedBy", equalTo: PFUser.currentUser())
            questionsCountQuery.countObjectsInBackgroundWithBlock({ (count, error) -> Void in
                if error == nil {
                    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                        self.questionsCreatedLabel.text = "Questions Created: \(count)"
                    })
                }
                else {
                    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                        UIAlertView(title: "Error", message: error.description, delegate: nil, cancelButtonTitle: "OK").show()
                    })
                }
            })

            // count questions answered
            var answersCountQuery = PFQuery(className: "Answer")
            answersCountQuery.whereKey("answeredBy", equalTo: PFUser.currentUser())
            answersCountQuery.countObjectsInBackgroundWithBlock({ (count, error) -> Void in
                if error == nil {
                    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                        self.questionsAnsweredLabel.text = "Questions Answered: \(count)"
                    })
                }
                else {
                    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                        UIAlertView(title: "Error", message: error.description, delegate: nil, cancelButtonTitle: "OK").show()
                    })
                }
            })
        }
        else
        {
            self.nameLabel.text = "Guest"
            self.login.setTitle("Login", forState: UIControlState.Normal)
            self.profilePictureImage.hidden = true
            self.questionsAnsweredLabel.hidden = true
            self.questionsCreatedLabel.hidden = true
            self.uploadProfilePictureButton.hidden = true
        }
    }

    @IBAction func logout(sender: AnyObject) {
        if PFUser.currentUser() != nil {
            PFUser.logOut()
            updateLabels()
        }
        else {
            presentLoginViewController()
        }

    }



    @IBAction func uploadProfilePicture(sender: AnyObject) {
        var imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }

    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        let smallImage = resizeImgage(image, factor: 0.25)

        let pfImage = PFFile(name: "profile_picture.png", data: UIImagePNGRepresentation(smallImage))
        PFUser.currentUser().setObject(pfImage, forKey: "profile_picture")
        PFUser.currentUser().saveInBackgroundWithBlock { (success, error) -> Void in
            if error == nil {
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    self.profilePictureImage.image = image
                })
            }
            else {
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    UIAlertView(title: "Error", message: error.description, delegate: nil, cancelButtonTitle: "OK").show()
                })
            }
        }

        self.dismissViewControllerAnimated(true, completion: nil)
    }

    func resizeImgage(originalImage:UIImage, factor:CGFloat) -> UIImage
    {
        var newSize = CGSizeMake(originalImage.size.width*factor, originalImage.size.height*factor);

        UIGraphicsBeginImageContext(newSize)
        originalImage.drawInRect(CGRectMake(0,0,newSize.width,newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();

        return newImage
    }

}
