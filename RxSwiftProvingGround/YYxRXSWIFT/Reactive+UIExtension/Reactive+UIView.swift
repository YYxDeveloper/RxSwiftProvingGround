//
//  Reactive+UIView.swift
//  RxSwiftProvingGround
//
//  Created by Young Lu on 2020/5/18.
//  Copyright © 2020 呂子揚. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

extension Reactive where Base: UIView {
  public var isHidden: Binder<Bool> {
      return Binder(self.base) { view, hidden in
          view.isHidden = hidden
      }
  }
}
