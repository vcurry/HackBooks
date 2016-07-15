//
//  AppDelegate.swift
//  HackBooks
//
//  Created by Verónica Cordobés on 28/6/16.
//  Copyright © 2016 Verónica Cordobés. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let urlData: NSData
        
        if let jsonData = defaults.dataForKey("json") {
            urlData = jsonData
        } else {
            let url = NSURL(string: "https://t.co/K9ziV0z3SJ")
            urlData = NSData(contentsOfURL: url!)!
            defaults.setObject(urlData, forKey: "json")
        }

        
        
        do{
            let json : [AnyObject] = try NSJSONSerialization.JSONObjectWithData(urlData, options: []) as! [AnyObject]
            
            var books = [Book]()
            for dict in json{
                do{
                    let book = try decode(book: dict as! JSONDictionary)
                    books.append(book)
                }catch{
                    print("Error al procesar \(dict)")
                }
            }
            
            
            
            window = UIWindow(frame: UIScreen.mainScreen().bounds)
            //Podemos crear el modelo
            let model = Library(allBooks: books)
            
            //Crear un VC
            let lVC = LibraryViewController(model:model)
            
            // Lo metemos en un nav
            let lNav = SegmentViewController(rootViewController: lVC)
            
            
            //Creamos un BookVC
            let bookVC = BookViewController(model: model.bookAtIndex(0)!)

            
            //Lo metemos en otro Navigation
            let bookNav = UINavigationController(rootViewController: bookVC)
            
            //Asignamos delegados
            lVC.delegate = bookVC
            
            //Creamos un SplitView
            let splitVC = UISplitViewController()
            splitVC.viewControllers = [lNav, bookNav]
 
            if(UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Phone){
                window?.rootViewController = lNav
            } else {
                window?.rootViewController = splitVC
            }
            
            
            //Nav como root View controller
            //window?.rootViewController = splitVC
            
 
            //hacer visible & key a la window
            window?.makeKeyAndVisible()
 
            return true
      
        }catch{
            fatalError("Error while loading JSON")
        }

 
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
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

