//
//  UIExtensions.swift
//  Readyt
//
//  Created by Raul Martinez Padilla on 01/09/2018.
//  Copyright © 2018 Raul Martinez Padilla. All rights reserved.
//

import UIKit

extension UITextField {
  convenience init(text: String) {
    self.init(frame: .zero)
    font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.heavy)
    autocorrectionType = UITextAutocorrectionType.no
    autocapitalizationType = UITextAutocapitalizationType.none
    placeholder = text
    borderStyle = .roundedRect
  }
}

extension DateFormatter {
  convenience init(withFormat format: String) {
    self.init()
    dateFormat = format
  }
}

extension UIScreen {
  public static var mainWidth: CGFloat {
    return UIScreen.main.bounds.width
  }
}

extension UILabel {
  convenience init(text: String) {
    self.init(frame: .zero)
    font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.heavy)
    self.text = text
  }
}

extension UIDatePicker {
  convenience init(withMode mode: UIDatePicker.Mode) {
    self.init(frame: .zero)
    date = Date()
    datePickerMode = mode
  }
}

extension UIButton {
  convenience init(text: String) {
    self.init(frame: .zero)
    setTitle(text, for: .normal)
    setTitleColor(.blue, for: .normal)
  }
}

extension UIView {

  func addConstraintsWithFormat(format: String, views: UIView...) {
    var viewsDict = [String: UIView]()
    for (index, view) in views.enumerated() {
      let key = "v\(index)"
      view.translatesAutoresizingMaskIntoConstraints = false
      viewsDict[key] = view
    }

    addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format,
                                                  options: NSLayoutConstraint.FormatOptions(),
                                                  metrics: nil,
                                                  views: viewsDict))
  }

  func anchor(top: NSLayoutYAxisAnchor? = nil,
              leading: NSLayoutXAxisAnchor? = nil,
              bottom: NSLayoutYAxisAnchor? = nil,
              trailing: NSLayoutXAxisAnchor? = nil,
              padding: UIEdgeInsets = .zero,
              size: CGSize = .zero) {

    translatesAutoresizingMaskIntoConstraints = false

    if let top = top {
      topAnchor.constraint(equalTo: top, constant: padding.top).isActive              = true
    }
    if let leading = leading {
      leadingAnchor.constraint(equalTo: leading, constant: padding.left).isActive     = true
    }
    if let bottom = bottom {
      bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom).isActive     = true
    }
    if let trailing = trailing {
      trailingAnchor.constraint(equalTo: trailing, constant: -padding.right).isActive = true
    }
    if size.width != 0 {
      widthAnchor.constraint(equalToConstant: size.width).isActive = true
    }
    if size.height != 0 {
      heightAnchor.constraint(equalToConstant: size.width).isActive = true
    }
  }
}

public extension Int {
  var pixels: Int {
    return Int(round(CGFloat(self) / UIScreen.main.scale))
  }

  var cgPixels: CGFloat {
    return CGFloat(pixels)
  }

  func pointsToPixels() -> CGFloat {
    return CGFloat(ceil(CGFloat(self) / UIScreen.main.scale))
  }
}
