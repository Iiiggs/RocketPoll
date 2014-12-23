////
////  ParseTester.swift
////  ParseStarterProject
////
////  Created by Igor Kantor on 12/22/14.
////
////
//
////import Cocoa
//
//class ParseTester: UIViewController, FBLoginViewDelegate {
//    var user: FBGraphUser?
//
//    @IBAction func inviteFriends(sender: AnyObject) {
//    }
//    override func viewDidLoad() {
////        addParseUser()
//
//        // add login button
//        var loginView = FBLoginView()
//        loginView.center = self.view.center
//        loginView.delegate = self
//        self.view.addSubview(loginView)
//    }
//
//    func loginView(loginView: FBLoginView!, handleError error: NSError!) {
//
//    }
//
//    func loginViewShowingLoggedInUser(loginView: FBLoginView!) {
//
//    }
//
//    func loginViewShowingLoggedOutUser(loginView: FBLoginView!) {
//
//    }
//
//    func loginViewFetchedUserInfo(loginView: FBLoginView!, user: FBGraphUser!) {
//        self.user = user
////        getMySocialPollingFriends(user)
//        sendRequestsToFriends()
//    }
//
//    func sendRequestsToFriends(){
//        FBWebDialogs.presentFeedDialogModallyWithSession(PFFacebookUtils.session(), parameters: nil, handler: { (result, url, error) -> Void in
//            if error == nil{
//                println(result)
//            }
//            else {
//                println(error)
//            }
//        })
//    }
//
//    func getMySocialPollingFriends(user: FBGraphUser!){
//        FBRequestConnection.startWithGraphPath("/\(user.objectID)/friends/", completionHandler: { (connection, result, error) -> Void in
//            if error == nil{
//                println(result)
//            }
//            else {
//                println(error)
//            }
//            
//        })
//    }
//
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
//}
