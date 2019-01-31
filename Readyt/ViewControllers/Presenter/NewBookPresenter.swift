//
//  NewBookPresenter.swift
//  Readyt
//
//  Created by Raul Martinez Padilla on 06/09/2018.
//  Copyright © 2018 Raul Martinez Padilla. All rights reserved.
//

//swiftlint:disable function_body_length

import UIKit
import Kingfisher

class NewBookPresenter: Presenter {

  var newBackButton: UIBarButtonItem!

  let toolBar = UIToolbar()
  var doneButton: UIBarButtonItem!

  let scrollView: UIScrollView = {
    let sView = UIScrollView(frame: .zero)

    sView.flashScrollIndicators()
    sView.scrollsToTop = true
    sView.alwaysBounceHorizontal = false
    sView.alwaysBounceVertical   = false

    return sView
  }()

  let mainContent: UIView = {
    let mContent = UIView(frame: .zero)

    return mContent
  }()

  let coverImage = UIImageView(frame: .zero)

  let titlelabel = UILabel(text: "Title")
  let titleField = UITextField(text: "Title")

  let authorLabel = UILabel(text: "Author")
  let authorField = UITextField(text: "Author")

  let startDateLabel = UILabel(text: "Start Date:")
  let startDateField = UITextField(text: "")
  let startDatePicker = UIDatePicker(withMode: .date)

  let endDateLabel = UILabel(text: "End Date:")
  let endDateField = UITextField(text: "")
  let endDatePicker = UIDatePicker(withMode: .date)

  var rating: RatingControl = RatingControl(frame: .zero)

  let descriptionLabel = UILabel(text: "Description")
  let descriptionField: UITextView = {
    let dField = UITextView(frame: .zero)

    dField.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.headline)
    dField.isSelectable = false
    dField.isScrollEnabled = false

    return dField
  }()

  let saveButton = UIButton(text: "Save")
  let cancelButton = UIButton(text: "Cancel")

  override func setupViews() {
    guard let newBookVC = (viewController as? NewBookViewController)
      else { fatalError("Wrong casting to NewBookViewController")}

    viewController.view.backgroundColor = .white
    viewController.navigationItem.title = newBookVC.viewModel.title.value

    if let url = newBookVC.viewModel.book?.apiInfo?.volumeInfo.imageLinks?.thumbnail {
      let placeholderImage = UIImage(named: "icons8-book_filled")
      let httpsURL = URL(string: url.replacingOccurrences(of: "http", with: "https"))
      let processor = ResizingImageProcessor(referenceSize: CGSize(width: 120, height: 120))

      coverImage.kf.setImage(with: httpsURL,
                             placeholder: placeholderImage,
                             options: [.transition(.fade(0.2)),
                                       .processor(processor)])
      coverImage.contentMode = .scaleAspectFit
      coverImage.layer.borderColor = UIColor.lightGray.cgColor
      coverImage.layer.borderWidth = 1
    }

    addViews()
    setAnchors()
    createDatePicker()
  }

  func addViews() {

    viewController.view.addSubview(scrollView)

    scrollView.addSubview(mainContent)

    [titlelabel, titleField,
     authorLabel, authorField,
     rating,
     coverImage,
     startDateLabel, startDateField, endDateLabel, endDateField,
     descriptionLabel, descriptionField,
     saveButton, cancelButton].forEach { (view) in
      mainContent.addSubview(view)
    }
  }

  func setAnchors() {
    scrollView.anchor(top: viewController.view.topAnchor,
                      leading: viewController.view.leadingAnchor,
                      bottom: viewController.view.bottomAnchor,
                      trailing: viewController.view.trailingAnchor,
                      padding: .init(top: 0, left: 0, bottom: 0, right: 0))

    mainContent.anchor(top: scrollView.topAnchor,
                       leading: viewController.view.leadingAnchor,
                       bottom: scrollView.bottomAnchor,
                       trailing: viewController.view.trailingAnchor,
                       padding: .init(top: 0, left: 0, bottom: 0, right: 0))

    // Inside scrollView
    titlelabel.anchor(top: mainContent.topAnchor,
                      leading: mainContent.leadingAnchor,
                      trailing: mainContent.trailingAnchor,
                      padding: .init(top: 20, left: 10, bottom: 0, right: 10))
    titleField.anchor(top: titlelabel.bottomAnchor,
                      leading: mainContent.leadingAnchor,
                      trailing: mainContent.trailingAnchor,
                      padding: .init(top: 10, left: 10, bottom: 0, right: 10))
    authorLabel.anchor(top: titleField.bottomAnchor,
                       leading: mainContent.leadingAnchor,
                       trailing: mainContent.trailingAnchor,
                       padding: .init(top: 20, left: 10, bottom: 0, right: 10))
    authorField.anchor(top: authorLabel.bottomAnchor,
                       leading: mainContent.leadingAnchor,
                       trailing: mainContent.trailingAnchor,
                       padding: .init(top: 10, left: 10, bottom: 0, right: 10))
    startDateLabel.anchor(top: authorField.bottomAnchor,
                          leading: mainContent.leadingAnchor,
                          trailing: mainContent.trailingAnchor,
                          padding: .init(top: 20, left: 10, bottom: 0, right: 10))
    startDateField.anchor(top: startDateLabel.bottomAnchor,
                          leading: mainContent.leadingAnchor,
                          trailing: coverImage.leadingAnchor,
                          padding: .init(top: 10, left: 10, bottom: 0, right: 10))
    endDateLabel.anchor(top: startDateField.bottomAnchor,
                        leading: mainContent.leadingAnchor,
                        trailing: coverImage.leadingAnchor,
                        padding: .init(top: 20, left: 10, bottom: 0, right: 10))
    endDateField.anchor(top: endDateLabel.bottomAnchor,
                        leading: mainContent.leadingAnchor,
                        trailing: coverImage.leadingAnchor,
                        padding: .init(top: 10, left: 10, bottom: 0, right: 10))
    coverImage.anchor(top: authorField.bottomAnchor,
                      trailing: mainContent.trailingAnchor,
                      padding: .init(top: 20, left: 10, bottom: 0, right: 10),
                      size: CGSize(width: 120, height: 120))
    rating.anchor(top: endDateField.bottomAnchor,
                  leading: mainContent.leadingAnchor,
                  padding: .init(top: 10, left: 10, bottom: 0, right: 10))
    descriptionLabel.anchor(top: rating.bottomAnchor,
                            leading: mainContent.leadingAnchor,
                            padding: .init(top: 20, left: 10, bottom: 0, right: 10))
    descriptionField.anchor(top: descriptionLabel.bottomAnchor,
                            leading: mainContent.leadingAnchor,
                            trailing: mainContent.trailingAnchor,
                            padding: .init(top: 10, left: 10, bottom: 0, right: 10))
    saveButton.anchor(top: descriptionField.bottomAnchor,
                      leading: mainContent.leadingAnchor,
                      padding: .init(top: 20, left: 100, bottom: 0, right: 50),
                      size: CGSize(width: 80, height: 30))
    cancelButton.anchor(top: descriptionField.bottomAnchor,
                        leading: saveButton.trailingAnchor,
                        bottom: mainContent.bottomAnchor,
                        padding: .init(top: 20, left: 0, bottom: 0, right: 0),
                        size: CGSize(width: 80, height: 30))

  }

  func createDatePicker() {
    toolBar.sizeToFit()
    doneButton = UIBarButtonItem(barButtonSystemItem: .done,
                                 target: self,
                                 action: #selector(dismissDatePicker(_ :)))
    toolBar.setItems([doneButton], animated: true)

    startDateField.inputAccessoryView = toolBar
    endDateField.inputAccessoryView = toolBar
  }

  @objc func dismissDatePicker(_ button: UIBarButtonItem) {
    guard let viewC = (viewController as? NewBookViewController) else { fatalError() }

    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd/MM/yyyy"

    let newValue: String

    switch viewC.choosedDatePicker {
    case .startDate:
      newValue = dateFormatter.string(from: startDatePicker.date)
      endDatePicker.minimumDate = startDatePicker.date
      startDateField.text = newValue
    case .endDate:
      newValue = dateFormatter.string(from: endDatePicker.date)
      startDatePicker.maximumDate = endDatePicker.date
      endDateField.text = newValue
    default:
      break
    }

    viewC.choosedDatePicker = .none
    viewController.view.endEditing(true)
  }

}
