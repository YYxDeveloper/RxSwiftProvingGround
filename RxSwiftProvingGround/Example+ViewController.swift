//
//  Example+ViewController.swift
//  RxSwiftProvingGround
//
//  Created by 呂子揚 on 2020/4/25.
//  Copyright © 2020 呂子揚. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
extension ViewController{
    func exampleBehaviorSubject() {
        let disposeBag = DisposeBag()
        
        //创建一个BehaviorSubject
        let subject = BehaviorSubject(value: "111")
        
        //第1次订阅subject
        subject.subscribe { event in
            print("第1次订阅：", event)
        }.disposed(by: disposeBag)
        
        //发送next事件
        subject.onNext("222")
        
        //发送error事件
        subject.onError(NSError(domain: "local", code: 0, userInfo: nil))
        
        //第2次订阅subject
        subject.subscribe { event in
            print("第2次订阅：", event)
        }.disposed(by: disposeBag)
    }
    func exampleAsyncSubject() {
        let subject = AsyncSubject<String>()
        
        subject
            .subscribe { print("Subscription: 1 Event:", $0) }
            .disposed(by: disposeBag)
        
        subject.onNext("🐶")
        subject.onNext("🐱")
        subject.onNext("🐹")
        subject.onCompleted()
    }
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
    func exampleJustAndFromArray() {
        /**
         https://stackoverflow.com/questions/44832750/observe-array-in-swift-3-using-rxswift
         that the from or just operator is called will be final set of emissions on the onNext events and will end with an onCompleted event.
         */
        
        //https://beeth0ven.github.io/RxSwift-Chinese-Documentation/content/decision_tree/just.html
        //just操作符將某一個元素轉換為Observable
        
        //https://beeth0ven.github.io/RxSwift-Chinese-Documentation/content/decision_tree/from.html
        //將其他類型或者數據結構轉換為 Observable
        
        let stream : Observable<Int> = Observable.from([1,2,3])
        stream.subscribe({print($0)}).disposed(by: disposeBag)
        let singleEmissionStream : Observable<[Int]> = Observable.just([1,2,3])
        singleEmissionStream.subscribe({print($0)}).disposed(by: disposeBag)
        
    }
    func exampleSchedule() {
        let rxData: Observable<[Int]> =  Observable.just([1,2,3])
        rxData
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .userInitiated))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] data in
                self?.redLabel.text = String(data[0])
            })
            .disposed(by: disposeBag)
    }
}
