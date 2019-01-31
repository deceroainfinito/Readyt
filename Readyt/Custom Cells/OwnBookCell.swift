//
//  OwnBookCell.swift
//  Readyt
//
//  Created by Raul Martinez Padilla on 17/09/2018.
//  Copyright © 2018 Raul Martinez Padilla. All rights reserved.
//

import UIKit
import Kingfisher

class OwnBookCell: BaseCustomCell {

  var book: Book? {
    didSet {
      if let url = book?.apiInfo?.volumeInfo.imageLinks?.thumbnail {
        let placeholderImage = UIImage(named: "icons8-book_filled")
        let httpsURL = URL(string: url.replacingOccurrences(of: "http", with: "https"))
        let processor = ResizingImageProcessor(referenceSize: CGSize(width: 70, height: 70))

        coverImage.kf.setImage(with: httpsURL,
                               placeholder: placeholderImage,
                               options: [.transition(.fade(0.2)),
                                         .processor(processor)])
        coverImage.contentMode = .scaleAspectFit
        coverImage.layer.borderColor = UIColor.lightGray.cgColor
        coverImage.layer.borderWidth = 1
      }

      if let title = book?.title {
        titleLabel.text = title
      }

      if let author = book?.author {
        authorLabel.text = author
      }
    }
  }

  static let width: CGFloat  = UIScreen.mainWidth - 20
  static let height: CGFloat = 120

  let cellSize = CGSize(width: OwnBookCell.width,
                        height: OwnBookCell.height)

  var coverImage: UIImageView = {
    let cImage = UIImageView(frame: .zero)

    return cImage
  }()

  var titleLabel: UILabel = {
    let tLabel = UILabel(frame: .zero)
    tLabel.numberOfLines = 2
    tLabel.lineBreakMode = .byWordWrapping
    tLabel.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.black)

    return tLabel
  }()

  var authorLabel: UILabel = {
    let aLabel = UILabel(frame: .zero)
    aLabel.numberOfLines = 2
    aLabel.lineBreakMode = .byWordWrapping
    aLabel.font = UIFont.systemFont(ofSize: 14, weight: .light)

    return aLabel
  }()

  override func setupViews() {
    [coverImage, titleLabel, authorLabel].forEach { addSubview($0) }

    coverImage.anchor(top: topAnchor,
                      leading: leadingAnchor,
                      bottom: nil,
                      trailing: nil,
                      padding: .init(top: 10, left: 10, bottom: 0, right: 0),
                      size: CGSize(width: 70, height: 70))

    titleLabel.anchor(top: topAnchor,
                      leading: coverImage.trailingAnchor,
                      bottom: nil,
                      trailing: trailingAnchor,
                      padding: .init(top: 10, left: 10, bottom: 0, right: 0))

    authorLabel.anchor(top: titleLabel.bottomAnchor,
                       leading: coverImage.trailingAnchor,
                       bottom: nil,
                       trailing: trailingAnchor,
                       padding: .init(top: 10, left: 10, bottom: 0, right: 0))
  }

}
