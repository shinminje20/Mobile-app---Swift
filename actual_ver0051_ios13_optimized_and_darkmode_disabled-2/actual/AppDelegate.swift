//
//  AppDelegate.swift
//  actual
//
//  Created by Sukkwon On on 2019-03-17.
//  Copyright © 2019 Sukkwon On. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation
import Firebase
import GoogleSignIn
import KakaoOpenSDK
import GoogleMaps
import GooglePlaces

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
    var window: UIWindow?
    var locationManager: CLLocationManager?
    
    // Restrict rotation
    var restrictRotation:UIInterfaceOrientationMask = .portrait
    
    // For ListingViewController
    var fetchingMore = false
    var reloadingStatus = false
    var fetchingStartPoint = -1
    var testProperty = [Property]()
    var displayedImages = [UIImage]()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        locationManager = CLLocationManager()
        locationManager?.requestWhenInUseAuthorization()
        FirebaseApp.configure()
        
        //Google maps
        GMSServices.provideAPIKey("AIzaSyDfGi70TMrtg6BUr_k12O-g7om_xpI-HxQ")
        GMSPlacesClient.provideAPIKey("AIzaSyDfGi70TMrtg6BUr_k12O-g7om_xpI-HxQ")
        
        // Google login
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        // Kakao login
        KOSession.shared()?.token?.accessToken
        KOSession.shared()?.token?.refreshToken
        
        
        let user = Auth.auth().currentUser
        if user != nil {
            // Reset the root view controller
            
            loadCollectionTestProperty()
            window = UIWindow(frame: UIScreen.main.bounds)
            window?.rootViewController = UIStoryboard(name: "LaunchScreen", bundle: nil).instantiateInitialViewController()
            window?.makeKeyAndVisible()
            
//            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
//
//            }
        }
        
        return true
    }
    
    private func loadCollectionTestProperty() {
        
        var db: Firestore!
        db = Firestore.firestore()
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
        
        var reference = db.collection("NorthAmerica").document("Canada").collection("BC").order(by: "timeStamp", descending: true).limit(to: 5)
        
        reference.getDocuments(){ (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                let group = DispatchGroup()
                for document in querySnapshot!.documents {
                    
                    if let newProperty = Property(dictionary: document.data()) {
                        newProperty.address.fullAddress = newProperty.address.address+", "+newProperty.address.city+", "+newProperty.address.province
                        self.fetchingStartPoint = newProperty.timeStamp
                        newProperty.documentID = document.documentID
                        print("\(newProperty.timeStamp)")
                        group.enter()
                        let myURL = newProperty.imageURL[0]
                        self.downloadImage(from: URL(string: myURL)!, completion: {(success) -> Void in
                            if self.displayedImages.count == 1 {
                                newProperty.images = self.displayedImages
                                self.testProperty.append(newProperty)
                                self.displayedImages = []
                                group.leave()
                            }
                        })
                        
                    } else {
                        
                        print("Document does not exist")
                    }
                }
                group.notify(queue: DispatchQueue.main) {
                    print("*************")
                    print("NOW BYE")
                    print("*************")
                    
                    self.fetchingMore = false
                    
                    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                    let tabVC = storyBoard.instantiateViewController(withIdentifier: "ListTabBarViewController") as! ListTabBarViewController
                    
                    tabVC.fetchingMore = self.fetchingMore
                    tabVC.reloadingStatus = self.reloadingStatus
                    tabVC.fetchingStartPoint = self.fetchingStartPoint
                    tabVC.testProperty = self.testProperty
                    tabVC.displayedImages = self.displayedImages
                    
                    self.window?.rootViewController = tabVC
                }
            }
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL, completion: @escaping (_ success: Bool) -> Void) {
        print("Download Started")
        
        let queue = DispatchQueue(label: "imageLoad", attributes: .concurrent)
        
        queue.async {
            self.getData(from: url) { data, response, error in
                guard let data = data, error == nil else { return }
                print(response?.suggestedFilename ?? url.lastPathComponent)
                print("Download Finished")
                self.displayedImages.append(UIImage(data: data)!)
                // Call completion, when finished, success or faliure
                completion(true)
            }
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        self.saveContext()
    }
    
    // Restrict rotation
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask
    {
        return self.restrictRotation
    }

    // for google signin for ios 9 or later
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any])
        -> Bool {
            if GIDSignIn.sharedInstance().handle(url,
                                                     sourceApplication:options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                                                     annotation: [:]){
                return GIDSignIn.sharedInstance().handle(url,
                                                         sourceApplication:options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                                                         annotation: [:])
                
            }
            
//            if KOSession.isKakaoAccountLoginCallback(url) {
//                        return KOSession.handleOpen(url)
//                    }
            if KOSession.isKakaoAccountLoginCallback(url.absoluteURL) {
              return KOSession.handleOpen(url)
            }
            return true

    }
    
    // for google signin for ios 8 or older
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        if (GIDSignIn.sharedInstance().handle(url,
        sourceApplication: sourceApplication,
        annotation: annotation)){
        return GIDSignIn.sharedInstance().handle(url,
                                                 sourceApplication: sourceApplication,
                                                 annotation: annotation)
        }
        
//        if KOSession.isKakaoAccountLoginCallback(url) {
//                return KOSession.handleOpen(url)
//        }
        if KOSession.isKakaoAccountLoginCallback(url.absoluteURL) {
          return KOSession.handleOpen(url)
        }
        
        return true
    }

    // google sign in
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print("AppDelegate.swift - error : sign(), ", error)
            return
        }
        
        guard let idToken = user.authentication.idToken else {return}
        guard let accessToken = user.authentication.accessToken else {return}
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                       accessToken: accessToken)
        
        print("======================================")
        print("AUTHENTICATION")
        print("======================================")
        print(authentication.idToken)
        print(authentication.accessToken)
        print("======================================")
        // ...

        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                print("AppDelegate.swift - error : sign(), Auth.auth().signIn(with: credential) { (authResult, error) in", error)
                return
            }
            
            let user = Auth.auth().currentUser
            let photoURL:String = user!.photoURL!.absoluteString
            let uid:String = user!.uid
            let displayName:String = user!.displayName!
            let email:String = user!.email!
            let data = [
                "uid" : uid,
                "photoURL" : photoURL,
                "email" : email,
                "displayName" : displayName
                ] as [String : Any]
            
            print("Publish ready")
            
            print(data)
            
            var db: Firestore!
            db = Firestore.firestore()
            
            db.collection("User").document(uid).setData(data) { err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written!")
                    self.loadCollectionTestProperty()
                }
            }
//            // Reset the root view controller
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let nav = storyboard.instantiateViewController(withIdentifier: "ListTabBarViewController")

            self.window?.rootViewController = nav
            print("User is signed in")
            
            // User is signed in
            // ...
        }

    }
    
    // google sign in
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print("Appdelegate.swift : sign() - error : ",error)
        }
        
        // Perform any operations when the user disconnects from app here.
        // ...
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "roomX")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
//    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
//        return GIDSignIn.sharedInstance().handle(url,
//                                                 sourceApplication: sourceApplication,
//                                                 annotation: annotation)
//    }
    
//    ============================================Kakaotalk Login======================================================================
//    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
//
//    }
//    func application((UIApplication *)application openURL:(NSURL *)url
//    sourceApplication:(NSString *)sourceApplication
//           annotation:(id)annotation)
//    (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
//                                           sourceApplication:(NSString *)sourceApplication
//                                                  annotation:(id)annotation {
////        ...
//        if ([KOSession isKakaoAccountLoginCallback:url]) {
//            return [KOSession handleOpenURL:url];
//        }
////        ...
//    }

//    (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
//                                                     options:(NSDictionary<NSString *,id> *)options {
////        ...
//        if ([KOSession isKakaoAccountLoginCallback:url]) {
//            return [KOSession handleOpenURL:url];
//        }
//        ...
//    }
//
//    (void)applicationDidBecomeActive:(UIApplication *)application
//    {
//        [KOSession handleDidBecomeActive];
//    }

    
}
