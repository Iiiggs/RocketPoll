//
//  AppDelegate.swift
//  SocialPolling
//
//  Created by Igor Kantor on 12/19/14.
//  Copyright (c) 2014 Igor Kantor. All rights reserved.
//


//TODO

//On Ask click, collect responses and save to model
//- what is the best modeling pattern/library? mvvm support?





import UIKit
import CoreData
import Parse

@UIApplicationMain
class PollingAppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var facebookUser: FBGraphUser?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        FBAppEvents.activateApp()

        ParseCrashReporting.enable();

        //Parse.setApplicationId("HzV2hHIkPkjzIRyAfsVPozcB9ZemavFNurRqliYB", clientKey: "BoR07Tovxpg1hpJ6Q5ypmm6YESeObx4gStaWmdnf")

        Parse.setApplicationId("hh0OVgMMPgDaS2b6cmSY7RweUZDu09NtYF0LuOUS", clientKey: "cUzd7P3xSY54V2O6pA6oQ6RK0QOHGR2qEKHfSrDx")

        PFFacebookUtils.initializeFacebook()

        PFTwitterUtils .initializeWithConsumerKey("AKLOk4eRciUE8YtaNuxkFjR8G", consumerSecret: "YKBKBK9Cdpg4owXdKIcbB8XqIgQzrwOzVNRl49JiLyxarQqY9w")

        registerForPush(application)

        PFAnalytics.trackAppOpenedWithLaunchOptionsInBackground(launchOptions, block: nil)

//        FBLoginView.self(()


//        let defaults = NSUserDefaults.standardUserDefaults()
//        if defaults.boolForKey("welcome_shown") == false {
//            var vc = UIViewController()
//            self.window?.rootViewController = UIViewController()
//
//            defaults.setBool(true, forKey: "welcome_shown")
//        }

        return true
    }

    func registerForPush(application: UIApplication){
        let types: UIUserNotificationType =
            [UIUserNotificationType.Badge, UIUserNotificationType.Alert, UIUserNotificationType.Sound]

        application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: types, categories: nil))
        application.registerForRemoteNotifications()
    }




    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData)
    {
        let installation = PFInstallation.currentInstallation()

        installation.setDeviceTokenFromData(deviceToken)
        installation.saveInBackgroundWithBlock { (success, error) -> Void in
            if success {
                if PFUser.currentUser() != nil {
                    // if all went well, register for our own channel
                    let install = PFInstallation.currentInstallation()
                    install.setObject(["questions_to_\(PFUser.currentUser().objectId)", "answers_to_\(PFUser.currentUser().objectId)"], forKey: "channels")
                    install.saveInBackgroundWithBlock({ (success, error) -> Void in
                        if error != nil {
                            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                                UIAlertView(title: "Error", message: error.description, delegate: nil, cancelButtonTitle: "OK").show()
                            })
                        }
                    })
                }
            }
            else
            {
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    UIAlertView(title: "Error", message: error.description, delegate: nil, cancelButtonTitle: "OK").show()
                })
            }
        }
    }

    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
//        UIAlertView(title: "Error", message: error.description, delegate: nil, cancelButtonTitle: "OK").show()
    }

    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        PFPush.handlePush(userInfo)
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        FBAppCall.handleDidBecomeActiveWithSession(PFFacebookUtils.session())

        if(PFInstallation.currentInstallation().badge != 0){
            PFInstallation.currentInstallation().badge = 0
            PFInstallation.currentInstallation().saveEventually()
        }
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return FBAppCall.handleOpenURL(url, sourceApplication:sourceApplication,
            withSession:PFFacebookUtils.session())
    }
    
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.igorware.CoreDataTest2" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1] 
        }()

}

