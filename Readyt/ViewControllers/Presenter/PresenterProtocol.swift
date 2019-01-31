//
//  PresenterProtocol.swift
//  Readyt
//
//  Created by Raul Martinez Padilla on 01/09/2018.
//  Copyright © 2018 Raul Martinez Padilla. All rights reserved.
//

import UIKit

protocol PresenterDelegate: class {
  var viewController: UIViewController! { get set }

  func setupViews()
}

class Presenter: PresenterDelegate {
  var viewController: UIViewController!

  func setupViews() { }
}

extension Presenter {
  convenience init(withViewController viewController: UIViewController) {
    self.init()
    self.viewController = viewController
  }
}
