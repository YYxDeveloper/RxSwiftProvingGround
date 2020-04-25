//
//  ViewController.swift
//  RxSwiftProvingGround
//
//  Created by 呂子揚 on 2020/4/23.
//  Copyright © 2020 呂子揚. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
class ViewController: UIViewController {
    
    @IBOutlet weak var redLabel: UILabel!
    @IBOutlet weak var yellowBtn: UIButton!
    var disposeBag = DisposeBag()
    let timer = Observable<Int>.interval(0.1, scheduler: MainScheduler.instance)
    let numbers: Observable<Int> = Observable.create { observer -> Disposable in
        
        observer.onNext(0)
        //        observer.onNext(1)
        observer.onCompleted()
        
        return Disposables.create()
    }
    
    let theObserver: AnyObserver<Int> = AnyObserver { (event) in
        switch event {
        case .next(let data):
            print(data)
        case .error(let error):
            print("Data Task Error: \(error)")
        default:
            break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        exampleAsSingle()
        
        
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
    
}

