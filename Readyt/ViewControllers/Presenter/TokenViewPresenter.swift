//
//  TokenViewPresenter.swift
//  Readyt
//
//  Created by Raul Martinez Padilla on 01/09/2018.
//  Copyright © 2018 Raul Martinez Padilla. All rights reserved.
//

import UIKit

class TokenViewPresenter: Presenter {

  var newBackButton: UIBarButtonItem!

  var tokenLabel: UILabel = {
    let tokenLabel = UILabel(frame: .zero)

    tokenLabel.text = "Goolge Books Token"
    tokenLabel.tintColor = UIColor.black
    tokenLabel.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.heavy)

    return tokenLabel
  }()

  var tokenField: UITextField = {
    let tokenField = UITextField(frame: .zero)

    tokenField.borderStyle = UITextField.BorderStyle.bezel
    tokenField.autocorrectionType = UITextAutocorrectionType.no
    tokenField.autocapitalizationType = UITextAutocapitalizationType.none

    return tokenField
  }()

  override func setupViews() {

    viewController.view.backgroundColor = UIColor.white
    viewController.view.addSubview(tokenLabel)
    viewController.view.addSubview(tokenField)

    viewController.navigationItem.title = "Token"

    tokenLabel.anchor(top: viewController.view.topAnchor,
                      leading: viewController.view.leadingAnchor,
                      trailing: viewController.view.trailingAnchor,
                      padding: .init(top: 300, left: 100, bottom: 0, right: 100) )
    tokenField.anchor(top: tokenLabel.bottomAnchor,
                      leading: viewController.view.leadingAnchor,
                      trailing: viewController.view.trailingAnchor,
                      padding: .init(top: 20, left: 20, bottom: 0, right: 20) )
  }
}
