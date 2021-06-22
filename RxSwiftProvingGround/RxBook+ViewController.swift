//
//  RxBook+ViewController.swift
//  RxSwiftProvingGround
//
//  Created by 呂子揚 on 2021/5/5.
//  Copyright © 2021 呂子揚. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
extension ViewController{
    func rxBook_createObservales() {
        // 1
        enum MyError: Error {
            case anError
        }
        let disposeBag = DisposeBag()
        Observable<String>.create { observer in
            // 1
            observer.onNext("1")
            // observer.onError(MyError.anError)
            // 2
            // observer.onCompleted()
            // 3
            observer.onNext("?")
            // 4
            return Disposables.create()
        }
        .subscribe(
            onNext: { print($0) },
            onError: { print($0) },
            onCompleted: { print("Completed") },
            onDisposed: { print("Disposed") }
        )
        .disposed(by: disposeBag)
        
    }
    func rxBook_range(){
        // 1
        let observable = Observable.range(start: 1, count: 10)
        
        observable .subscribe(onNext: { i in
            
            // 2
            //            let n = Double(i)
            //            let fibonacci = Int(((pow(1.61803, n) - pow(0.61803, n)) / 2.23606).rounded())
            print(i)
        })
    }
    func rxBook_concatMap(){
        // 1
        let sequences = [
            
            "Germany": Observable.of("Berlin", "Münich", "Frankfurt"),
            
            "Spain": Observable.of("Madrid", "Barcelona", "Valencia") ]
        
        // 2
        let observable = Observable.of("Germany", "Spain") .concatMap { country in sequences[country] ?? .empty()}
        
        // 3
        _ = observable.subscribe(onNext: { string in
            
            print(string)
            
        })
        
    }
    func rxBook_concat() {
        let germanCities = Observable.of("Berlin", "Münich", "Frankfurt")
        
        let spanishCities = Observable.of("Madrid", "Barcelona", "Valencia")
        
        let observable = germanCities.concat(spanishCities)
        observable.subscribe(onNext: { value in print(value) }).disposed(by: disposeBag)
    }
    func rxBook_withLatestFrom(){
        let button = PublishSubject<Void>()
        
        let textField = PublishSubject<String>()
        
        // 2
        //        let observable = button.withLatestFrom(textField)
        let observable = textField.sample(button)
        
        _ = observable.subscribe(onNext: { value in print(value) })
        // 3
        textField.onNext("Par")
        textField.onNext("Pari")
        textField.onNext("Paris")
        button.onNext(())
        button.onNext(())
        
    }
    func rxBook_sample(){
        let disposeBag = DisposeBag()
        
        let source = PublishSubject<Int>()
        let notifier = PublishSubject<String>()
        
        source
            .sample(notifier)
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
        
        source.onNext(1)
        
        //讓源序列接收接收消息
        notifier.onNext("")
        
        source.onNext(2)
        
        //讓源序列接收接收消息
        notifier.onNext("")
        notifier.onNext("")
        
        source.onNext(3)
        source.onNext(4)
        
        //讓源序列接收接收消息
        notifier.onNext("")
        
        source.onNext(5)
        
        //讓源序列接收接收消息
        notifier.onCompleted()
    }
    func rxBook_amb(){
        let left = PublishSubject<String>()
        
        let right = PublishSubject<String>()
        
        let observable = left.amb(right)
        let disposable = observable.subscribe(onNext: { value in print(value) })
        
        // 2
        right.onNext("Copenhagen")
        
        left.onNext("Lisbon")
        //        right.onNext("Copenhagen")
        left.onNext("London")
        left.onNext("Madrid")
        right.onNext("Vienna")
        
        disposable.dispose()
    }
    func rxBook_switchLatest() {
        let one = PublishSubject<String>()
        let two = PublishSubject<String>()
        let three = PublishSubject<String>()
        let source = PublishSubject<Observable<String>>()
        
        let observable = source.switchLatest()
        let disposable = observable.subscribe(onNext: { value in print(value) })
        
        source.onNext(one)
        one.onNext("Some text from sequence one")
        two.onNext("Some text from sequence two")
        
        source.onNext(two)
        two.onNext("More text from sequence two")
        one.onNext("and also from sequence one")
        
        source.onNext(three)
        two.onNext("Why don't you see me?")
        one.onNext("I'm alone, help me")
        three.onNext("Hey it's three. I win.")
        
        source.onNext(one)
        one.onNext("Nope. It's me, one!")
    }
    func rxBook_delaySubscription(){
        
        let subject = PublishSubject<Int>()
        subject
            .delaySubscription(.seconds(3), scheduler: MainScheduler.instance) //延迟3秒才开始订阅
                   .subscribe(onNext: { print($0) })
                   .disposed(by: disposeBag)

        subject.onNext(6)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4, execute: {
            subject.onNext(6666)

        })
//        Observable.of(1, 2, 3, 4, 5).delaySubscription(.seconds(3), scheduler: MainScheduler.instance)
//            .subscribe({print($0)})
        
    }
    func rxBook_delay(){
//        _ =  Observable.of(1, 2, 3, 4, 5).delay(.seconds(3), scheduler: MainScheduler.instance)
//
//            .subscribe(onNext: { print($0) })
//            .disposed(by: disposeBag)
//        let subject = PublishSubject<Int>()
        
//        subject.delay(.seconds(3), scheduler: MainScheduler.instance).subscribe({
//            print($0)
//        })
//
//        subject.onNext(0)
//        subject.onNext(1)
//        subject.onNext(2)


        
    }
    func rxBook_interval(){

        _ = Observable<Int>.interval(.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(onNext: {
                let aa = $0
                print($0)
            })
            .disposed(by: disposeBag)
    }
    func rxBook_Timer(){
        /// 創建重複多次執行序列
               /// 參數1: 幾秒後開始第一次執行
               /// 參數2: 調度者
        let timer = Observable<Int>.timer(.seconds(3), period: .seconds(2),scheduler: MainScheduler.instance)

               /// 添加訂閱
               timer.subscribe { (event) in
                   // 執行代碼
                print(event)
               }.disposed(by: disposeBag)

       
    }
    func rxBook_timeout(){
        //定義好每個事件里的值以及發送的時間
               let times = [
                   [ "value": 1, "time": 0 ],
                   [ "value": 2, "time": 0.5 ],
                   [ "value": 3, "time": 1.5 ],
                   [ "value": 4, "time": 4 ],
                   [ "value": 5, "time": 5 ]
               ]
                
               //生成對應的 Observable 序列並訂閱
               Observable.from(times)
                   .flatMap { item in//DispatchTimeInterval
                       return Observable.of(Int(item["value"]!))
                        .delaySubscription(Double(item["time"]!),
                                              scheduler: MainScheduler.instance)
                   }
                .timeout(.seconds(2), scheduler: MainScheduler.instance) //超過兩秒沒發出元素，則產生error事件
                   .subscribe(onNext: { element in
                       print(element)
                   }, onError: { error in
                       print("error::\(error)")
                   })
                   .disposed(by: disposeBag)
    }
    
}
