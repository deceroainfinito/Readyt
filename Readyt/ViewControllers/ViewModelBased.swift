//
//  ViewModelBased.swift
//  Readyt
//
//  Created by Raul Martinez Padilla on 18/09/2018.
//  Copyright © 2018 Raul Martinez Padilla. All rights reserved.
//

import UIKit

protocol ViewModelBased: class {
  associatedtype ViewModel

  var viewModel: ViewModel! { get set }
}

extension ViewModelBased where Self:UIViewController {
  static func instantiate(with viewModel: ViewModel) -> Self {
    let viewController = Self()

    viewController.viewModel = viewModel

    return viewController
  }
}
