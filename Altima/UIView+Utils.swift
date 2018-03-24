//
//  UIView+Utils.swift
//  Qrate
//
//  Created by Mikhail Rudenko on 22/05/2017.
//  Copyright © 2017 Qrate LLC. All rights reserved.
//

import UIKit

class Methods {
  public static func generateImageWithText(text: String, backgroundColor: UIColor, frame: CGRect) -> UIImage
    {
        let imageView = UIImageView.init(frame: frame)

        imageView.backgroundColor = backgroundColor

        let label = UILabel(frame: frame)
        label.backgroundColor = .clear
        label.textAlignment = .center
        label.textColor = .white
        //label.text = text.shortString()

        UIGraphicsBeginImageContextWithOptions(label.bounds.size, false, 0);
        imageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        label.layer.render(in: UIGraphicsGetCurrentContext()!)
        let imageWithText = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();

        return imageWithText!
    }
}

extension UIView {
    /// Радиус гараницы
    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }
    /// Толщина границы
    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    /// Цвет границы
    @IBInspectable var borderColor: UIColor? {
        set {
            layer.borderColor = newValue?.cgColor
        }
        get {
            return layer.borderColor?.UIColor
        }
    }
    /// Смещение тени
    @IBInspectable var shadowOffset: CGSize {
        set {
            layer.shadowOffset = newValue
        }
        get {
            return layer.shadowOffset
        }
    }
    /// Прозрачность тени

    @IBInspectable var shadowOpacity: Float {
        set {
            layer.shadowOpacity = newValue
        }
        get {
            return layer.shadowOpacity
        }
    }
    /// Радиус блура тени
    @IBInspectable var shadowRadius: CGFloat {
        set {
            layer.shadowRadius = newValue
        }
        get {
            return layer.shadowRadius
        }
    }
    /// Цвет тени
    @IBInspectable var shadowColor: UIColor? {
        set {
            layer.shadowColor = newValue?.cgColor
        }
        get {
            return layer.shadowColor?.UIColor
        }
    }
    /// Отсекание по границе
    @IBInspectable var _clipsToBounds: Bool {
        set {
            clipsToBounds = newValue
        }
        get {
            return clipsToBounds
        }
    }

    func round(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}


extension CGColor {
    var UIColor: UIKit.UIColor {
        return UIKit.UIColor(cgColor: self)
    }
}
