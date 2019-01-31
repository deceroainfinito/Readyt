//
//  FoundBookListViewController.swift
//  Readyt
//
//  Created by Raul Martinez Padilla on 07/09/2018.
//  Copyright © 2018 Raul Martinez Padilla. All rights reserved.
//

import UIKit
import ReSwift
import RxSwift
import RxCocoa

class FoundBookListViewController: UIViewController {

  fileprivate var searchState: Variable<FoundBookListState>! = Variable(FoundBookListState.loading)

  fileprivate var foundBooks: Variable<[JSONDomain.Book?]>! = Variable([])

  var presenter: PresenterDelegate!

  var foundBooksPresenter: FoundBookListPresenter {
    guard let presenter = presenter as? FoundBookListPresenter else { fatalError() }
    return presenter
  }

  let backGesture: UISwipeGestureRecognizer = {
    let backG = UISwipeGestureRecognizer()
    backG.direction = .right

    return backG
  }()

  internal var disposeBag = DisposeBag()

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    store.subscribe(self) { subscription in
      subscription.select { state in
        state.foundBookList
      }
    }

  }

  override func viewDidDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)

    store.unsubscribe(self)
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    view.addGestureRecognizer(backGesture)

    foundBooksPresenter.newBackButton = UIBarButtonItem(title: "Back",
                                                   style: UIBarButtonItem.Style.plain,
                                                   target: self,
                                                   action: #selector(goBack))
    navigationItem.leftBarButtonItem = foundBooksPresenter.newBackButton

    presenter.setupViews()

    rxMagic()
  }

  fileprivate func rxMagic() {

    foundBooksPresenter.collectionView.delegate = nil
    foundBooksPresenter.collectionView.rx.setDelegate(self).disposed(by: disposeBag)

    collectionViewState()
    foundBooksManagement()
  }

  fileprivate func collectionViewState() {
    searchState
      .asObservable()
      .subscribe(onNext: { (result) in
        switch result {
        case .loading:
          self.foundBooksPresenter.collectionView.backgroundView =
            self.foundBooksPresenter.loadingCollectionViewBackground
          self.foundBooksPresenter.collectionView.backgroundView?.isHidden = false
        case .dataAvailable(let books):
          self.foundBooks.value = books
          self.foundBooksPresenter.collectionView.backgroundView?.isHidden = true
        case .noItemFound:
          self.foundBooksPresenter.collectionView.backgroundView =
            self.foundBooksPresenter.emptyCollectionViewBackground
          self.foundBooksPresenter.collectionView.backgroundView?.isHidden = false
        }
      }).disposed(by: disposeBag)
  }

  fileprivate func foundBooksManagement() {
    foundBooks
      .asObservable()
      .bind(to: foundBooksPresenter
        .collectionView
        .rx
        .items(cellIdentifier: "FoundBookCell")) { [weak self] (_, book, cell) in
          guard let bookCell = (cell as? FoundBookCell) else { fatalError("Wrong casting to FoundBookCell")}

          self?.foundBooksPresenter.collectionView.backgroundView?.isHidden = true

          bookCell.book = book
      }.disposed(by: disposeBag)

    foundBooksPresenter.collectionView
      .rx
      .itemSelected
      .subscribe(onNext: { [weak self] (indexPath) in
        guard let safeSelf = self,
          let selectedBook = safeSelf.foundBooks.value[indexPath.row] else { return }

        let selectedFoundBookState = SelectedBookState(selectedBook: Book(withApiInfo: selectedBook))

        store.dispatch(UpdateSelectedFoundBookAction(selectedFoundBook: selectedFoundBookState))
        store.dispatch(RoutingAction(destination: .selectedFoundBook))
      }).disposed(by: disposeBag)
  }

  @objc fileprivate func goBack() {
    navigationController?.popViewController(animated: true)
    store.dispatch(RoutingAction(destination: .bookSearch))
  }
}

extension FoundBookListViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {

    return CGSize(width: FoundBookCell.width, height: FoundBookCell.height)
  }

  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      minimumLineSpacingForSectionAt section: Int) -> CGFloat {

    return 10
  }
}

extension FoundBookListViewController: StoreSubscriber {
  typealias StoreSubscriberStateType = FoundBooksItemsState

  func newState(state: FoundBooksItemsState) {
    searchState.value = state.state
  }
}
