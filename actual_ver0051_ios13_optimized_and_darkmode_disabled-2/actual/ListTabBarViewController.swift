//
//  ListTabBarViewController.swift
//  actual
//
//  Created by Sukkwon On on 2019-03-17.
//  Copyright © 2019 Sukkwon On. All rights reserved.
//

import UIKit
import Firebase

class ListTabBarViewController: UITabBarController {
    let tabBarIconImages = [["list_searchOff", "list_searchOn"], ["list_favoriteOff", "list_favoriteOn"], ["list_postOff", "list_postOn"], ["list_settingOff", "list_settingOn"]]
    
    var fetchingMore = false
    var reloadingStatus = false
    var fetchingStartPoint = -1
    
    var testProperty = [Property]()
    var displayedImages = [UIImage]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let listingNav = self.viewControllers![0] as? UINavigationController
        let listingVC = listingNav!.topViewController as? ListingViewController
        
        listingVC?.fetchingMore = self.fetchingMore
        listingVC?.reloadingStatus = self.reloadingStatus
        listingVC?.fetchingStartPoint = self.fetchingStartPoint
        listingVC?.testProperty = self.testProperty
        listingVC?.displayedImages = self.displayedImages
    }
    
    override func awakeFromNib() {
        for i in 0...3 {
            tabBar.items?[i].image = UIImage(named: tabBarIconImages[i][0])
            tabBar.items?[i].selectedImage = UIImage(named: tabBarIconImages[i][1])
            tabBar.items?[i].imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
            tabBar.items?[i].title = nil
        }
        
        tabBar.tintColor = UIColor(rgb: 0x8389BA)
        tabBar.unselectedItemTintColor = UIColor(rgb: 0x8389BA)
        tabBar.barTintColor = UIColor(red: 255, green: 255, blue: 255)
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
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}
