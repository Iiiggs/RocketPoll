//
//  RootViewController.swift
//  SocialPolling
//
//  Created by Igor Kantor on 12/19/14.
//  Copyright (c) 2014 Igor Kantor. All rights reserved.
//

import UIKit

class RootViewController: UIViewController, UIPageViewControllerDelegate, FBLoginViewDelegate {

    var pageViewController: UIPageViewController?

    let landingViewControllerIndex = 0

    @IBOutlet weak var loginButton: UIButton!

    @IBOutlet weak var signupButton: UIButton!

    @IBOutlet weak var facebookLoginView: FBLoginView!

    @IBOutlet weak var surveyImage: UIImageView!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Rocket Poll"

        self.loginButton.contentEdgeInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        self.loginButton.layer.cornerRadius = 4.0
        self.loginButton.clipsToBounds = true
        applyExtraLightBlurToButtonBackground(self.loginButton, backgroundView: self.view)
        self.loginButton.layer.borderColor = UIColor.blackColor().CGColor
        self.loginButton.layer.borderWidth = 1.0


        self.signupButton.contentEdgeInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        self.signupButton.layer.cornerRadius = 4.0
        self.signupButton.clipsToBounds = true
        applyLightBlurToButtonBackground(self.signupButton, backgroundView: self.view)
        self.signupButton.layer.borderColor = UIColor.whiteColor().CGColor
        self.signupButton.layer.borderWidth = 1.0

        applyBlurToImageBackground(surveyImage, backgroundView: self.view)
        surveyImage.layer.cornerRadius = 4.0
        self.surveyImage.clipsToBounds = true
    }

    func applyBlurToImageBackground(imageView:UIImageView, backgroundView:UIView){
        let rect = imageView.convertRect(imageView.bounds, toView: backgroundView)
        UIGraphicsBeginImageContext(imageView.frame.size)
        backgroundView.drawViewHierarchyInRect(rect, afterScreenUpdates: true)
        let backgroundImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        let bluredImage = UIImageEffects.imageByApplyingExtraLightEffectToImage(backgroundImage)
        let foreGroundImage = imageView.image!
        UIGraphicsBeginImageContext(rect.size)

        bluredImage.drawInRect(CGRectMake(0,0,rect.size.width,rect.size.height))
        foreGroundImage.drawInRect(CGRectMake(0,0,rect.size.width,rect.size.height))


        let finalImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        imageView.image = finalImage

//        
//        UIGraphicsBeginImageContext(imageView.frame.size)
//        image.drawInRect(imageView.frame)
//        bluredImage.drawInRect(imageView.frame)
//
//
//        var final = UIGraphicsGetImageFromCurrentImageContext()
//
//        UIGraphicsEndImageContext()
//
//        imageView.image = final
    }

    func applyLightBlurToButtonBackground(button:UIButton, backgroundView:UIView){
        let rect = button.convertRect(button.bounds, toView: backgroundView)
        UIGraphicsBeginImageContext(button.frame.size)
        backgroundView.drawViewHierarchyInRect(CGRectMake(-rect.origin.x, -rect.origin.y, rect.size.width, rect.size.height), afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        let lightBlurredImage = UIImageEffects.imageByApplyingLightEffectToImage(image)

        button.setBackgroundImage(lightBlurredImage, forState: .Normal)
    }

    func applyExtraLightBlurToButtonBackground(button:UIButton, backgroundView:UIView){
        let rect = button.convertRect(button.bounds, toView: backgroundView)
        UIGraphicsBeginImageContext(button.frame.size)
        backgroundView.drawViewHierarchyInRect(CGRectMake(-rect.origin.x, -rect.origin.y, rect.size.width, rect.size.height), afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        let lightBlurredImage = UIImageEffects.imageByApplyingExtraLightEffectToImage(image)

        button.setBackgroundImage(lightBlurredImage, forState: .Normal)
    }

    func applyDarkBlurToButtonBackground(button:UIButton, backgroundView:UIView){
        let rect = button.convertRect(button.bounds, toView: backgroundView)
        UIGraphicsBeginImageContext(button.frame.size)
        backgroundView.drawViewHierarchyInRect(CGRectMake(-rect.origin.x, -rect.origin.y, rect.size.width, rect.size.height), afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        let lightBlurredImage = UIImageEffects.imageByApplyingDarkEffectToImage(image)

        button.setBackgroundImage(lightBlurredImage, forState: .Normal)
    }



    func loginView(loginView: FBLoginView!, handleError error: NSError!) {
        
    }

    // Show login
    override func viewDidAppear(animated: Bool) {

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var modelController: ModelController {
        // Return the model controller object, creating it if necessary.
        // In more complex implementations, the model controller may be passed to the view controller.
        if _modelController == nil {
            _modelController = ModelController()
        }
        return _modelController!
    }

    var _modelController: ModelController? = nil

    // MARK: - UIPageViewController delegate methods

    func pageViewController(pageViewController: UIPageViewController, spineLocationForInterfaceOrientation orientation: UIInterfaceOrientation) -> UIPageViewControllerSpineLocation {
        if (orientation == .Portrait) || (orientation == .PortraitUpsideDown) || (UIDevice.currentDevice().userInterfaceIdiom == .Phone) {
            // In portrait orientation or on iPhone: Set the spine position to "min" and the page view controller's view controllers array to contain just one view controller. Setting the spine position to 'UIPageViewControllerSpineLocationMid' in landscape orientation sets the doubleSided property to YES, so set it to NO here.
            let currentViewController = self.pageViewController!.viewControllers![0] as UIViewController
            let viewControllers : [UIViewController] = [currentViewController]
            self.pageViewController!.setViewControllers(viewControllers, direction: .Forward, animated: true, completion: {done in })

            self.pageViewController!.doubleSided = false
            return .Min
        }

        // In landscape orientation: Set set the spine location to "mid" and the page view controller's view controllers array to contain two view controllers. If the current page is even, set it to contain the current and next view controllers; if it is odd, set the array to contain the previous and current view controllers.
        let currentViewController = self.pageViewController!.viewControllers![0] as! PollingViewControllerBase
        var viewControllers: [UIViewController]

        let indexOfCurrentViewController = self.modelController.indexOfViewController(currentViewController)
        if (indexOfCurrentViewController == 0) || (indexOfCurrentViewController % 2 == 0) {
            let nextViewController = self.modelController.pageViewController(self.pageViewController!, viewControllerAfterViewController: currentViewController)
            viewControllers = [currentViewController, nextViewController!]
        } else {
            let previousViewController = self.modelController.pageViewController(self.pageViewController!, viewControllerBeforeViewController: currentViewController)
            viewControllers = [previousViewController!, currentViewController]
        }
        self.pageViewController!.setViewControllers(viewControllers, direction: .Forward, animated: true, completion: {done in })

        return .Mid
    }

    func nextPage(){
        let i = 0

        let vc = self.modelController.viewControllerAtIndex(i, storyboard: self.storyboard!)

        self.pageViewController!.setViewControllers([vc!], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: { (res) -> Void in
                                    })
    }

    @IBAction func createAccountPressed(sender: AnyObject) {
        let signupViewController = storyboard!.instantiateViewControllerWithIdentifier("SignupViewController") as! SignupViewController

        self.navigationController?.presentViewController(signupViewController, animated: true, completion: nil)
    }


    @IBAction func loginWithEmailPressed(sender: AnyObject) {
        let loginViewController = storyboard!.instantiateViewControllerWithIdentifier("LoginViewController")as! LoginViewController

        self.navigationController?.presentViewController(loginViewController, animated: true, completion: nil)

    }

}

