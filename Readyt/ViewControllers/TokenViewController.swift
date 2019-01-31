//
//  TokenViewController.swift
//  Readyt
//
//  Created by Raul Martinez Padilla on 31/08/2018.
//  Copyright © 2018 Raul Martinez Padilla. All rights reserved.
//

import UIKit
import ReSwift
import RxSwift
import RxCocoa

class TokenViewController: UIViewController {

  internal var disposeBag = DisposeBag()

  var presenter: PresenterDelegate!

  var tokenPresenter: TokenViewPresenter {
    guard let presenter = presenter as? TokenViewPresenter else { fatalError() }
    return presenter
  }

  let backGesture: UISwipeGestureRecognizer = {
    let backG = UISwipeGestureRecognizer()
    backG.direction = .right

    return backG
  }()

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    store.subscribe(self) { subscription in
      subscription.select { state in
        state.token
      }
    }
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)

    store.dispatch(TokenChangeAction(token: TokenState(token: tokenPresenter.tokenField.text)))
    store.unsubscribe(self)
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    view.addGestureRecognizer(backGesture)

    tokenPresenter.newBackButton = UIBarButtonItem(title: "Back",
                                                     style: UIBarButtonItem.Style.plain,
                                                     target: self,
                                                     action: #selector(goBack))
    navigationItem.leftBarButtonItem = tokenPresenter.newBackButton

    presenter.setupViews()

    rxMagic()
  }

  fileprivate func rxMagic() {
    backGesture.rx.event.subscribe { (_) in
      self.goBack()
      }.disposed(by: disposeBag)
  }

  @objc fileprivate func goBack() {
    navigationController?.popViewController(animated: true)
    store.dispatch(RoutingAction(destination: .bookList))
  }
}

extension TokenViewController: StoreSubscriber {
  typealias StoreSubscriberStateType = TokenState

  func newState(state: TokenState) {
    //TODO: Sure???
    tokenPresenter.tokenField.text = state.token
  }
}
