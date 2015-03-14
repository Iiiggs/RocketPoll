//
//  CommentsViewController.swift
//  RocketPoll
//
//  Created by Igor Kantor on 3/14/15.
//
//

import UIKit

class CommentsViewController: UIViewController {

    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var commentTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let tap = UITapGestureRecognizer(target: self, action: "dissmissKeyboard")
        self.view.addGestureRecognizer(tap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "liftMainViewWhenKeyboardAppears:", name:UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "returnMainViewWhenKeyboardAppears:", name:UIKeyboardWillHideNotification, object: nil)

    }

    func liftMainViewWhenKeyboardAppears(notification:NSNotification){
        let info = notification.userInfo as NSDictionary!
        let durationValue = info[UIKeyboardAnimationDurationUserInfoKey] as NSNumber!
        let curveValue = info[UIKeyboardAnimationCurveUserInfoKey] as NSNumber!
        let endFrame = info[UIKeyboardFrameEndUserInfoKey] as NSValue!

        UIView.animateWithDuration(durationValue.doubleValue, animations: { () -> Void in
            self.toolbar.setTranslatesAutoresizingMaskIntoConstraints(true)

            self.toolbar.frame = CGRectMake(self.toolbar.frame.origin.x,
                                            endFrame.CGRectValue().origin.y - self.toolbar.bounds.size.height,
                                            self.toolbar.frame.size.width,
                                            self.toolbar.frame.size.height)
        })
    }

    func returnMainViewWhenKeyboardAppears(notification:NSNotification){
        let info = notification.userInfo as NSDictionary!
        let durationValue = info[UIKeyboardAnimationDurationUserInfoKey] as NSNumber!
        let curveValue = info[UIKeyboardAnimationCurveUserInfoKey] as NSNumber!


        UIView.animateWithDuration(durationValue.doubleValue, animations: { () -> Void in
            self.toolbar.setTranslatesAutoresizingMaskIntoConstraints(true)
            self.toolbar.frame = CGRectMake(self.toolbar.frame.origin.x,
                self.view.bounds.size.height - self.toolbar.bounds.size.height,
                self.toolbar.frame.size.width,
                self.toolbar.frame.size.height)
        })
    }

    func dissmissKeyboard(){
        self.commentTextField.resignFirstResponder()
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
