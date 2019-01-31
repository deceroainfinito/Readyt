//
//  RatingControl.swift
//  Readyt
//
//  Created by Raul Martinez Padilla on 21/09/2018.
//  Copyright © 2018 Raul Martinez Padilla. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RatingControl: UIStackView {

  private var ratingButtons = [UIButton()]
  var rating: Variable<Int> = Variable(0)

  var disposeBag = DisposeBag()

  override init(frame: CGRect) {
    super.init(frame: frame)

    spacing = 4
    setupButtons()

    rating.asObservable().subscribe(onNext: { (value) in
      self.setStars(value)
    }).disposed(by: disposeBag)
  }

  required init(coder: NSCoder) {
    fatalError("\(#function) not implemented")
  }

  private func setupButtons() {
    let disabledStarIcon = UIImage(named: "star_disabled")
    let enabledStarIcon = UIImage(named: "star")

    for index in 0..<5 {
      let button = UIButton()
      button.tag = index
      button.setImage(disabledStarIcon, for: .normal)
      button.setImage(enabledStarIcon, for: .selected)

      button.anchor(size: CGSize(width: 44, height: 44))

      button.rx.tap.bind {
        self.rating.value = (button.tag + 1 == self.rating.value) ? 0 : button.tag + 1
      }.disposed(by: disposeBag)

      addArrangedSubview(button)
      ratingButtons.append(button)
    }
  }

  func setStars(_ value: Int) {
    self.ratingButtons.forEach({ $0.isSelected = $0.tag < value })
  }
}
