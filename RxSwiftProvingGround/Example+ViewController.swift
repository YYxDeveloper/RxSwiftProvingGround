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
import UIKit
import RxDataSources

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
    //如果后一个元素和前一个元素不相同，那么这个元素才会被发出来
    func exampleDistinctUntilChanged() {
        Observable.of("🐱", "🐷", "🐱", "🐱", "🐱", "🐵", "🐱")
        .distinctUntilChanged()
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)

        
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
    func example_BehaviorSubject_appendElement()  {
        //Subject 既是 Observer 也是 Observable 。它可以订阅一个或多个 Observable，当收到消息后进行处理，也可以通过Event将数据发送给订阅者。
        //四者区别在于：当一个新的订阅者订阅它的时候，能否收到Subject以前发出过的就的Event，如果可以的会，又能收到多少个
        let subject = BehaviorSubject(value: [10, 20])
        subject.asObserver().subscribe(onNext: { value in
            print(value)
        }).disposed(by: disposeBag)
        do {
            try subject.onNext(subject.value() + [40]) // concatenating older value with new
        } catch {
            print(error)
        }
        
    }
    func example_BehaviorRelay_appendElement(){
        let array = BehaviorRelay(value: [1, 2, 3])

        array.subscribe(onNext: { value in
            print(value)
        }).disposed(by: disposeBag)


        // for changing the value, simply get current value and append new value to it
        array.accept(array.value + [4])
    }
    func example_BehaviorRelay_convertBackArray() {
        
        //        https://stackoverflow.com/questions/49244270/rxswift-how-to-append-to-behaviorsubject?rq=1
        let subject = BehaviorRelay(value: ["A"])
        subject.asObservable().subscribe(onNext: { element in
            print("第1次订阅：", element)
        }, onCompleted: {
            print("第1次订阅：completed")
        }).disposed(by: disposeBag)
        
        subject.accept( subject.value + ["B"])
        subject.asObservable().subscribe(onNext: { element in
            print("第2次订阅：", element)
        }, onCompleted: {
            print("第2次订阅：completed")
        }).disposed(by: disposeBag)
        
        subject.accept( subject.value+["C"])
        
        let arr = subject.value
        print("orignal array ::\(arr)")
    }
    func exampleTextfieldBindLabel() {
        //        bind(to: redLabel.rx.text)
        //              .disposed(by: disposeBag)
        
        let observable = textField.rx.text
        //        observable.subscribe(onNext: { text in
        //
        //        })
        observable
            .bind(to:  redLabel.rx.text)
            .disposed(by: disposeBag)
    }
    func exampleAsDrive() {
        //https://www.hangge.com/blog/cache/detail_1964.html
        let input = textField.rx.text.orEmpty.asDriver() // 将普通序列转换为 Driver
            .throttle(0.3) //在主线程中操作，0.3秒内值若多次改变，取最后一次
        
        //内容绑定到文本标签中
        input.map{ "当前字数：\($0.count)" }
            .drive(redLabel.rx.text)
            .disposed(by: disposeBag)
        
        //根据内容字数决定按钮是否可用
        input.map{ $0.count > 5 }
            .drive(yellowBtn.rx.isEnabled)
            .disposed(by: disposeBag)
        
    }
    func exampleRxTableView() {
       
    }
    
}
