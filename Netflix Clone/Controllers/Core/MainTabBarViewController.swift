//
//  ViewController.swift
//  Netflix Clone
//
//  Created by Amin  Bagheri  on 2022-06-20.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemYellow
        
        // we are instantiating instances of these view controllers and we are adding them to be under a navigatoin controller so that when we push to movie details, we get to have the back button and all other functionality etc
        let vc1 = UINavigationController(rootViewController: HomeViewController())
        let vc2 = UINavigationController(rootViewController: UpcomingViewController())
        let vc3 = UINavigationController(rootViewController: SearchViewController())
        let vc4 = UINavigationController(rootViewController: DownloadsViewController())
        
        
        //creating the images for each tab in the tab bar controller
        vc1.tabBarItem.image = UIImage(systemName: "house")
        vc2.tabBarItem.image = UIImage(systemName: "play.circle")
        vc3.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        vc4.tabBarItem.image = UIImage(systemName: "arrow.down.to.line")

        //pretty self explanatory, but here we are setting the title of each of the tab bar tiem to be its respective tirle
        vc1.title = "Home"
        vc2.title = "Coming Soon"
        vc3.title = "Search"
        vc4.title = "Downloads"
        
        // setting the color of each tab bar item
        tabBar.tintColor = .label
        
        // this sets the view controllers of the tab bar controller (the individual tabs) to be the viewControllers we initiated
        setViewControllers([vc1, vc2, vc3, vc4], animated: true)
        
    }


}

