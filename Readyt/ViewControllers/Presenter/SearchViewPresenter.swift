//
//  SearchViewPresenter.swift
//  Readyt
//
//  Created by Raul Martinez Padilla on 07/09/2018.
//  Copyright © 2018 Raul Martinez Padilla. All rights reserved.
//

import UIKit

class SearchViewPresenter: Presenter {

  var newBackButton: UIBarButtonItem!

  let isbnField: UITextField = UITextField(text: "ISBN Number")
  let authorField: UITextField = UITextField(text: "Author")
  let titleField: UITextField = UITextField(text: "Title")

  let searchButton: UIButton = {
    let sButton = UIButton(frame: .zero)

    sButton.setTitle("Search", for: .normal)
    sButton.setTitleColor(.blue, for: .normal)
    sButton.setTitleColor(.gray, for: .disabled)

    return sButton
  }()

  override func setupViews() {
    viewController.view.backgroundColor = .white
    viewController.navigationItem.title = "Book Search"

    authorField.text = ""

    viewController.view.addSubview(isbnField)
    viewController.view.addSubview(authorField)
    viewController.view.addSubview(titleField)
    viewController.view.addSubview(searchButton)

    isbnField.anchor(top: viewController.view.topAnchor,
                     leading: viewController.view.leadingAnchor,
                     trailing: viewController.view.trailingAnchor,
                     padding: .init(top: 300, left: 70, bottom: 0, right: 70))
    authorField.anchor(top: isbnField.bottomAnchor,
                       leading: viewController.view.leadingAnchor,
                       trailing: viewController.view.trailingAnchor,
                       padding: .init(top: 20, left: 70, bottom: 0, right: 70))
    titleField.anchor(top: authorField.bottomAnchor,
                      leading: viewController.view.leadingAnchor,
                      trailing: viewController.view.trailingAnchor,
                      padding: .init(top: 20, left: 70, bottom: 0, right: 70))
    searchButton.anchor(top: titleField.bottomAnchor,
                        leading: viewController.view.leadingAnchor,
                        trailing: viewController.view.trailingAnchor,
                        padding: .init(top: 40, left: 70, bottom: 0, right: 70))
    searchButton.heightAnchor.constraint(equalToConstant: 40)

  }
}
