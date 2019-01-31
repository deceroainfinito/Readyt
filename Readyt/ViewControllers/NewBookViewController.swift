//
//  NewBookViewController.swift
//  Readyt
//
//  Created by Raul Martinez Padilla on 05/09/2018.
//  Copyright © 2018 Raul Martinez Padilla. All rights reserved.
//

import UIKit

import ReSwift
import RxSwift
import RxCocoa

enum ChoosedDatePicker {
  case none
  case startDate
  case endDate
}

class NewBookViewController: UIViewController, ViewModelBased {
  typealias ViewModel = BookViewModel

  var viewModel: BookViewModel!

  var presenter: PresenterDelegate!

  var newBookPresenter: NewBookPresenter {
    guard let presenter = presenter as? NewBookPresenter else { fatalError() }

    return presenter
  }

  let dismissGesture: UITapGestureRecognizer = {
    let dismissG = UITapGestureRecognizer()
    dismissG.numberOfTapsRequired = 1

    return dismissG
  }()

  let backGesture: UISwipeGestureRecognizer = {
    let backG = UISwipeGestureRecognizer()
    backG.direction = .right

    return backG
  }()

  var choosedDatePicker = ChoosedDatePicker.none

  internal var disposeBag = DisposeBag()

  override func viewDidLoad() {
    super.viewDidLoad()

    [backGesture, dismissGesture].forEach { view.addGestureRecognizer($0) }

    newBookPresenter.newBackButton = UIBarButtonItem(title: "Back",
                                                     style: UIBarButtonItem.Style.plain,
                                                     target: self,
                                                     action: #selector(goBack))
    navigationItem.leftBarButtonItem = newBookPresenter.newBackButton

    newBookPresenter.startDateField.inputView = newBookPresenter.startDatePicker
    newBookPresenter.endDateField.inputView = newBookPresenter.endDatePicker

    presenter.setupViews()

    rxMagic()

    viewModel.assignFirstValues()

    navigationItem.title = viewModel.title.value
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    store.subscribe(self) { subscription in
      subscription.select { state in
        state.selectedBook
      }
    }
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)

    //    let selectedBookState = SelectedBookState(selectedBook: selectedBook.getBook())

    store.unsubscribe(self)
  }

  func rxMagic() {
    bindFields()
    adjustDescriptionField()
    adjustDataPickers()
    bindButtons()
  }

  fileprivate func bindFields() {
    [newBookPresenter.titleField: viewModel.title,
     newBookPresenter.authorField: viewModel.author,
     newBookPresenter.startDateField: viewModel.startReadingDate,
     newBookPresenter.endDateField: viewModel.endReadingDate]
      .forEach { (field, viewModel) in

        field.rx.text.orEmpty.bind(to: viewModel).disposed(by: disposeBag)
        viewModel.asObservable().bind(to: field.rx.text).disposed(by: disposeBag)
    }

    newBookPresenter.descriptionField
      .rx.text.orEmpty.bind(to: viewModel.description).disposed(by: disposeBag)
    viewModel.description
      .asObservable().bind(to: newBookPresenter.descriptionField.rx.text).disposed(by: disposeBag)

    newBookPresenter.rating.rating.asObservable().bind(to: viewModel.rating).disposed(by: disposeBag)
    viewModel.rating.asObservable().subscribe(onNext: { (value) in
      guard let safeValue = value else { return }
      //TODO: Quite ugly!
      self.newBookPresenter.rating.setStars(safeValue)
    }).disposed(by: disposeBag)
  }

  fileprivate func bindButtons() {
    newBookPresenter.saveButton.rx.tap.subscribe { (_) in
      if let index = store.state.selectedBookIndex.index {
        let selectedBookState = SelectedBookState(selectedBook: self.viewModel.getBook())
        let selectedBookIndexState = SelectedBookIndexState(index: index)
        store.dispatch(UpdateBookAction(index: selectedBookIndexState, updatedBook: selectedBookState))
      } else {
        store.dispatch(AddNewBookAction(newBook: SelectedBookState(selectedBook: self.viewModel.getBook())))
      }

      store.dispatch(UpdateSelectedBookIndexAction(index: SelectedBookIndexState(index: nil)))
      store.dispatch(RoutingAction(destination: .bookList))
      }.disposed(by: disposeBag)

    newBookPresenter.cancelButton.rx.tap.subscribe { (_) in
      self.goBack()
      }.disposed(by: disposeBag)

    dismissGesture.rx.event.subscribe { (_) in
      self.view.endEditing(true)
      }.disposed(by: disposeBag)

    backGesture.rx.event.subscribe { (_) in
      self.goBack()
      }.disposed(by: disposeBag)
  }

  fileprivate func adjustDescriptionField() {
    newBookPresenter.descriptionField.rx.text.asObservable().subscribe(onNext: { [unowned self] (_) in
      let size = CGSize(width: self.view.frame.width, height: .infinity)
      let estimatedSize = self.newBookPresenter.descriptionField.sizeThatFits(size)

      self.newBookPresenter.descriptionField.constraints.forEach({ (constraint) in
        if constraint.firstAttribute == .height {
          constraint.constant = estimatedSize.height
        }
      })
    }).disposed(by: disposeBag)
  }

  fileprivate func adjustDataPickers() {
    let startTag = newBookPresenter.startDateField.rx
      .controlEvent([.editingDidBegin]).map { (_) -> ChoosedDatePicker  in
        return ChoosedDatePicker.startDate
    }
    let endTag = newBookPresenter.endDateField.rx
      .controlEvent([.editingDidBegin]).map { (_) -> ChoosedDatePicker  in
        return ChoosedDatePicker.endDate
    }

    let observableTag = Observable.of(startTag, endTag).merge()

    observableTag.subscribe(onNext: { (selection) in
      self.choosedDatePicker = selection
    }).disposed(by: disposeBag)
  }

  @objc fileprivate func goBack() {
    navigationController?.popViewController(animated: true)

    switch store.state.foundBookList.state {
    case .loading, .noItemFound:
      store.dispatch(RoutingAction(destination: .bookList))
    default:
      store.dispatch(RoutingAction(destination: .foundBookList))
    }
  }
}

extension NewBookViewController: StoreSubscriber {
  typealias StoreSubscriberStateType = SelectedBookState

  func newState(state: SelectedBookState) {
    //    guard let book = state.selectedBook else { return }
    //
    //    viewModel = BookViewModel(book: book)
  }
}
