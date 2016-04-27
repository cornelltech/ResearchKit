//
//  UIColor+String.swift
//  ORKCatalog
//
//  Created by James Kizer on 4/26/16.
//  Copyright © 2016 researchkit.org. All rights reserved.
//

import UIKit


// Assumes input like "#00FF00" (#RRGGBB).
//+ (UIColor *)colorFromHexString:(NSString *)hexString {
//    unsigned rgbValue = 0;
//    NSScanner *scanner = [NSScanner scannerWithString:hexString];
//    [scanner setScanLocation:1]; // bypass '#' character
//    [scanner scanHexInt:&rgbValue];
//    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
//}


extension UIColor {
    convenience init(hexString: String) {
        let scanner = NSScanner(string: hexString)
        scanner.scanLocation = 1
        var x: UInt32 = 0
        scanner.scanHexInt(&x)
        let red: CGFloat = CGFloat((x & 0xFF0000) >> 16)/255.0
        let green: CGFloat = CGFloat((x & 0xFF00) >> 8)/255.0
        let blue: CGFloat = CGFloat(x & 0xFF)/255.0
        self.init(red: red, green: green, blue: blue, alpha:1.0)
    }
}