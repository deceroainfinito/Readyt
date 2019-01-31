//
//  FoundBookListPresenter.swift
//  Readyt
//
//  Created by Raul Martinez Padilla on 07/09/2018.
//  Copyright © 2018 Raul Martinez Padilla. All rights reserved.
//

import UIKit

class FoundBookListPresenter: Presenter {

  let collectionView: UICollectionView = {
    let viewLayout = UICollectionViewFlowLayout()
    viewLayout.scrollDirection = UICollectionView.ScrollDirection.vertical
    let bookList = UICollectionView(frame: .zero, collectionViewLayout: viewLayout)

    bookList.register(FoundBookCell.self, forCellWithReuseIdentifier: "FoundBookCell")
    bookList.backgroundColor = UIColor.white

    return bookList
  }()

  let emptyCollectionViewBackground: UIView = {
    let backgroundView = UIView(frame: UIScreen.main.bounds)
    let emptyImage = UIImage(named: "basket-empty-icon")
    let emptyView = UIImageView(image: emptyImage)

    backgroundView.backgroundColor = .white
    emptyView.backgroundColor  = .white

    backgroundView.addSubview(emptyView)

    emptyView.translatesAutoresizingMaskIntoConstraints = false

    emptyView.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor).isActive = true
    emptyView.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor).isActive = true
    emptyView.widthAnchor.constraint(equalToConstant: 120).isActive = true
    emptyView.heightAnchor.constraint(equalToConstant: 120).isActive = true

    return backgroundView
  }()

  let loadingCollectionViewBackground: UIView = {
    let loadingView = UIView(frame: UIScreen.main.bounds)
    let loadingIndicator = UIActivityIndicatorView(style: .gray)
    loadingIndicator.startAnimating()

    loadingView.addSubview(loadingIndicator)

    loadingIndicator.translatesAutoresizingMaskIntoConstraints = false

    loadingIndicator.centerXAnchor.constraint(equalTo: loadingView.centerXAnchor).isActive = true
    loadingIndicator.centerYAnchor.constraint(equalTo: loadingView.centerYAnchor).isActive = true

    return loadingView
  }()

  var newBackButton: UIBarButtonItem!

  override func setupViews() {
    viewController.view.backgroundColor = UIColor.white
    viewController.navigationItem.title = "Found Books"

    collectionView.backgroundView = emptyCollectionViewBackground

    viewController.view.addSubview(collectionView)

    collectionView.anchor(top: viewController.view.safeAreaLayoutGuide.topAnchor,
                          leading: viewController.view.leadingAnchor,
                          bottom: viewController.view.safeAreaLayoutGuide.bottomAnchor,
                          trailing: viewController.view.trailingAnchor,
                          padding: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0))
  }
}
