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
    
    @IBOutlet weak var orangeLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var redLabel: UILabel!
    @IBOutlet weak var yellowBtn: UIButton!
    var disposeBag = DisposeBag()
//    let timer = Observable<Int>.interval(0.1, scheduler: MainScheduler.instance)
    let timer = Observable<Int>.interval(DispatchTimeInterval.seconds(1), scheduler: MainScheduler())

    let numbers: Observable<Int> = Observable.create { observer -> Disposable in
        
        observer.onNext(0)
        //        observer.onNext(1)
        observer.onCompleted()
        
        return Disposables.create()
    }
    let sliderNumber:BehaviorRelay<Float> = BehaviorRelay(value: 0.0)
    
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
    
    func mutualBinding() {
        sliderNumber.subscribe({data in
            print(data)
            }).disposed(by: disposeBag)
        _=slider.rx.value <-> self.sliderNumber
    }
    override func viewDidLoad() {
        super.viewDidLoad()
//        mutualBinding()
        // Do any additional setup after loading the view.
//        exampleObservableBindUI()
//        exampleTheObserver()
//        exampleAsSingle()
//        exampleAsyncSubject()
//        exampleRXConvertArray()
//        exampleBehaviorSubject()
//        example_BehaviorSubject_appendElement()
//        example_BehaviorRelay_appendElement()
//        example_BehaviorRelay_convertBackArray()
//        exampleSchedule()
//        exampleTextfieldBindLabel()
        exampleAsDrive()
//        exampleDistinctUntilChanged()
//        exampleRxTableView()
//        examplePublishSubject()
    }
    
}

