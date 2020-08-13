//
//  UIKitExtensions.swift
//  Scheduler
//
//  Created by Cezary Przygodzki on 20/07/2020.
//  Copyright © 2020 PekackaPrzygodzki. All rights reserved.
//

import Foundation

import  UIKit

extension UIView {
    
    func pin(to superView: UIView){
        translatesAutoresizingMaskIntoConstraints                               = false
        topAnchor.constraint(equalTo: superView.topAnchor).isActive             = true
        leadingAnchor.constraint(equalTo: superView.leadingAnchor).isActive     = true
        trailingAnchor.constraint(equalTo: superView.trailingAnchor).isActive   = true
        bottomAnchor.constraint(equalTo: superView.bottomAnchor).isActive       = true
        
    }
}
extension UINavigationController {

    func setStatusBar(backgroundColor: UIColor) {
        let statusBarFrame: CGRect
        if #available(iOS 13.0, *) {
            statusBarFrame = view.window?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero
        } else {
            statusBarFrame = UIApplication.shared.statusBarFrame
        }
        let statusBarView = UIView(frame: statusBarFrame)
        statusBarView.backgroundColor = backgroundColor
        view.addSubview(statusBarView)
    }

}
extension UIButton{
    
    func makeRounded(diameter: CGFloat) {

        self.frame.size.width = diameter
        self.frame.size.height = diameter
        self.layer.masksToBounds = false
        self.layer.cornerRadius = self.frame.size.height / 2
        self.clipsToBounds = true
    }
    
    func setProfileButton (button: String){
        self.setBackgroundImage(UIImage(systemName: button), for: .normal)
        self.tintColor = .white
    }
    
    
}

extension UITextField{
    
    enum PaddingSide {
        case left(CGFloat)
        case right(CGFloat)
        case both(CGFloat)
    }
    
    func addPadding(_ padding: PaddingSide) {

        self.leftViewMode = .always
        self.layer.masksToBounds = true


        switch padding {

            case .left(let spacing):
                let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: spacing, height: self.frame.height))
                self.leftView = paddingView
                self.rightViewMode = .always

            case .right(let spacing):
                let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: spacing, height: self.frame.height))
                self.rightView = paddingView
                self.rightViewMode = .always

            case .both(let spacing):
                let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: spacing, height: self.frame.height))
                // left
                self.leftView = paddingView
                self.leftViewMode = .always
                // right
                self.rightView = paddingView
                self.rightViewMode = .always
        }
    }
    
    func centerAndColorPlaceholder(color: UIColor, placeholder: String){
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        self.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: color , NSAttributedString.Key.paragraphStyle: paragraph])
    }
}




