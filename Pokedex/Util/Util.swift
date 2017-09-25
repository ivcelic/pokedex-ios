//
//  Util.swift
//  Pokedex
//
//  Created by Iris on 23/09/2017.
//  Copyright © 2017 Iris Veronika Celic. All rights reserved.
//

import Foundation
import UIKit

class Util: NSObject {
    
    static let kActivityIndicatorViewTag: Int = 5
    
    static func readFromPlist(key: String) -> String? {
        guard let plist = Bundle.main.infoDictionary else {
            return ""
        }
        
        guard let value: String = plist[key] as? String else {
            return ""
        }
        
        return value
    }
    
    static func basicBlueColor() -> UIColor {
        return UIColor(red: 59.0/255.0, green: 89.0/255.0, blue: 152.0/255.0, alpha: 1.00)
    }
    
    static func showProgressDialog(view: UIView) {
        let superView: UIView = view
        superView.isUserInteractionEnabled = false
        let indicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        indicator.center = superView.center
        indicator.tag = Util.kActivityIndicatorViewTag
        indicator.isHidden = false
        superView.addSubview(indicator)
        superView.bringSubview(toFront: indicator)
        indicator.startAnimating()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    static func hideProgressDialog(view: UIView) {
        view.isUserInteractionEnabled = true
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        view.viewWithTag(Util.kActivityIndicatorViewTag)?.removeFromSuperview()
    }
    
    
    
}
