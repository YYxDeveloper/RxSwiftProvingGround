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
            .subscribe { print("Subscription: 1 Event:", $0.element) }
            .disposed(by: disposeBag)
        
        subject.onNext("AA")
        subject.onNext("VV")
        subject.onNext("CC")
        subject.onCompleted()
        subject.onNext("CC")
        
    }
    func exampleSubscipeWithEvent(){
        //        let output = viewModel?.transform(AuthLoginViewModel.Input(loginTrigger: loginTrigger))
        //        output?.loginRequest.asObservable().subscribe({ event in
        //            switch event {
        //            case .next(let model):
        //                print(model)
        //            case .error(let error):
        //                print(error)
        //            default: break
        //            }
        //        }).disposed(by: disposeBag)
    }
    func exampleDriverSubscribe()     {
        let subject = AsyncSubject<String>().asDriver(onErrorDriveWith: .empty())
        //        subject
        //            .subscribe { print("Subscription: 1 Event:", $0.element) }
        //            .disposed(by: disposeBag)
        //
        //        subject.onNext("AA")
        //        subject.onNext("VV")
        //        subject.onNext("CC")
        //        subject.onCompleted()
        //        subject.onNext("CC")
        subject.drive(onNext: { _ in
            
        }, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        
        subject.drive()
        
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
        
        input.map{ $0 + "最後都有gg" }
            .drive(orangeLabel.rx.text)
            .disposed(by: disposeBag)
        
    }
    func exampleRxTableView() {
        
    }
    func examplePublishSubject() {
        let subject = PublishSubject<String>()
        
        subject
            .subscribe { print("Subscription: 1 Event:", $0) }
            .disposed(by: disposeBag)
        
        subject.onNext("🐶")
        subject.onNext("🐱")
        
        subject
            .subscribe { print("Subscription: 2 Event:", $0.element) }
            .disposed(by: disposeBag)
        
        subject.onNext("🅰️")
        subject.onNext("🅱️")
    }
    func exampleDoAllEvent(){
        let subject = PublishSubject<Int>()

        let ob = subject.do(onNext: {
            print("====onNext\($0)")
        },
        afterNext: { _ in
            print("===afterNext")
        },
        onError: { _ in
            print("onError")
        },
        afterError: { _ in
            print("afterError")
        },
        onCompleted: {
            print("onCompleted")
        },
        afterCompleted: {
            print("afterCompleted")
        },
        onSubscribe: {
            print("onSubscribe")
        },
        onSubscribed: {
            print("onSubscribed")
        },
        onDispose: {
            print("onDispose")
        }).subscribe({_ in
            print("====")
        }).disposed(by: disposeBag)
        subject.subscribe({print($0)}).disposed(by: disposeBag)

        subject.onNext(5)
//        subject.onNext(2)
//        ob.subscribe({print($0)}).disposed(by: disposeBag)
        
    }
    func example_different_of_And_create(){
        //差別在於一個會自動onCompleted另外一個要手動
        Observable.of("1", "2").subscribe(onCompleted: {
            print("cccompleted")
        }).disposed(by: disposeBag)

        Observable<String>.create { observer in
                observer.onNext("1")
                observer.onNext("2")
            observer.onCompleted()
                return Disposables.create()
            }
            .subscribe(onCompleted: {
                print("aacompleted")
            }).disposed(by: disposeBag)
    }
    func example_replay(){
        let intSequence = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
            .replay(4)

        _ = intSequence
            .subscribe(onNext: { print("Subscription 1:, Event: \($0)") })

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            _ = intSequence.connect()
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
          _ = intSequence
              .subscribe(onNext: { print("Subscription 2:, Event: \($0)") })
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 8) {
          _ = intSequence
              .subscribe(onNext: { print("Subscription 3:, Event: \($0)") })
        }
    }
    func example_buffer(){
        let bufferTimeSpan: RxTimeInterval = RxTimeInterval.milliseconds(10000)
        let bufferMaxCount = 3
        let sourceObservable = PublishSubject<String>()
       

        sourceObservable .buffer(timeSpan: bufferTimeSpan, count: bufferMaxCount, scheduler: MainScheduler.instance)
            .subscribe({ event in
                
            print(event.element!)
        }).disposed(by: disposeBag)
        
        print("start")
        sourceObservable.onNext("a")
        sourceObservable.onNext("b")
        sourceObservable.onNext("b2")
        sourceObservable.onNext("b3")
        sourceObservable.onNext("d")
        sourceObservable.onNext("e")
        sourceObservable.onNext("f")
        sourceObservable.onNext("g")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
           print("timer")
            sourceObservable.onNext("g2")

        }
//        sourceObservable.onNext("c")
      
       

    }
    func example_window(){
        let subject = PublishSubject<String>()

        let aa = subject
            .window(timeSpan: 10, count: 2, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                print("subscribe: \($0)")
                $0.asObservable()
                    .subscribe(onNext: { print("ggg::\($0)") })
                    .disposed(by: self!.disposeBag)
            })
//            .disposed(by: disposeBag)

        subject.onNext("a")
        subject.onNext("b")
        subject.onNext("c")
        
        //運行結果：
        //subscribe: RxSwift.AddRef<Swift.String>
        //a
        //b
        //c
        //subscribe: RxSwift.AddRef<Swift.String>
        //subscribe: RxSwift.AddRef<Swift.String>
        //...    }
    }
    
}
