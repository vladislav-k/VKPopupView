//
//  TabBarController.swift
//  VKPopupViewExample
//
//  Created by Vladislav Kovalyov on 2/2/17.
//  Copyright © 2017 WOOPSS.com. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem)
    {
        let index = tabBar.items?.index(of: item)
        self.tabBar.barStyle = index == 0 ? .default : .black
    }
}
