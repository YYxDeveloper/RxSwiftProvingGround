//
//  Reactive+UIExtension.swift
//  RxSwiftProvingGround
//
//  Created by 呂子揚 on 2020/4/25.
//  Copyright © 2020 呂子揚. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
extension Reactive where Base: UIControl {
  public var isEnabled: Binder<Bool> {
      return Binder(self.base) { control, value in
          control.isEnabled = value
      }
  }
}
extension Reactive where Base: UILabel {
  public var text: Binder<String?> {
      return Binder(self.base) { label, text in
          label.text = text
      }
  }
}
