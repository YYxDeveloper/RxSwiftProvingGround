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
//        exampleObservableBindUI()
//        exampleTheObserver()
        exampleAsSingle()
        
        
    }
    
}

