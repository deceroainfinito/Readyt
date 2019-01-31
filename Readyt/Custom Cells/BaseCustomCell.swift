//
//  BaseCollectionCell.swift
//  Readyt
//
//  Created by Raul Martinez Padilla on 08/09/2018.
//  Copyright © 2018 Raul Martinez Padilla. All rights reserved.
//

import UIKit

protocol ViewsConfigurable {
  func setupViews()
}

class BaseCustomCell: UICollectionViewCell, ViewsConfigurable {
  override init(frame: CGRect) {
    super.init(frame: frame)

    setupViews()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func setupViews() { }
}
