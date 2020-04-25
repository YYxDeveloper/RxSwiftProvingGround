//
//  Example+ViewController.swift
//  RxSwiftProvingGround
//
//  Created by 呂子揚 on 2020/4/25.
//  Copyright © 2020 呂子揚. All rights reserved.
//

import Foundation
extension ViewController{
    func exampleAsSingle() {

           numbers.asSingle()
               .subscribe(onSuccess: { json in
                   print("JSON结果: ", json)
               }, onError: { error in
                   print("发生错误: ", error)
               })
               .disposed(by: disposeBag)
           
           numbers
           .asSingle()
           .subscribe({ print($0) })
           .disposed(by: disposeBag)
           
           
       }
       func exampleTheObserver() {
           numbers
               .subscribe(theObserver)
               .disposed(by: disposeBag)
       }
       func exampleObservableBindUI()  {
           timer.map{ String(format: "%0.2d:%0.2d.%0.1d",
                             arguments: [($0 / 600) % 600, ($0 % 600 ) / 10, $0 % 10]) }
               .bind(to: redLabel.rx.text)
               .disposed(by: disposeBag)
       }
}
