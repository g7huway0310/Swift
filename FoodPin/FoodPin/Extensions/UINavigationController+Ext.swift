//
//  UINavigationController+Ext.swift
//  FoodPin
//
//  Created by guowei on 2019/12/23.
//  Copyright © 2019 guowei. All rights reserved.
//

import UIKit

extension UINavigationController {
    
    open override var childForStatusBarStyle: UIViewController? {
        return topViewController
    }
    
}
