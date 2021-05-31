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
        observer.onNext(1)
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
    func bindYellowButton(){
        let tempSubject = PublishSubject<Int>()
        
        yellowBtn.rx.tap.subscribe({ob in
            tempSubject.onCompleted()
            
        }).disposed(by: disposeBag)
        
        tempSubject.subscribe({ event in
            let num = event.element
            print(num)
            
        }).disposed(by: disposeBag)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        bindYellowButton()
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
//        exampleAsDrive()
//        exampleDriverSubscribe()
//        exampleDistinctUntilChanged()
//        exampleRxTableView()
//        examplePublishSubject()
        
//        rxBook_createObservales()
//        exampleDoAllEvent()
//        rxBook_range()
//        rxBook_concatMap()
//        rxBook_concat()
//        rxBook_concatMap()
//        rxBook_withLatestFrom()
//        rxBook_sample()
//        rxBook_amb()
//        rxBook_switchLatest()
//        example_different_of_And_create()
//        example_replay()
//        example_buffer()
//        example_window()
        struct Zoo {
            let animal: BehaviorSubject<String>
        }
        let zone1 = Zoo(animal: BehaviorSubject<String>(value: "Koala"))
        let zone2 = Zoo(animal: BehaviorSubject<String>(value: "Lion"))

        let subject = PublishSubject<Zoo>()

        subject
            .concatMap { $0.animal }
            .subscribe(onNext: {
                print($0)
            })
            .disposed(by: disposeBag)

        subject.onNext(zone1)

        subject.onNext(zone2)

        
            
            
        zone1.animal.onNext("Panda")
        zone2.animal.onNext("Tiger")



        zone2.animal.onNext("Cow")
//        zone2.animal.onCompleted()
//        zone1.animal.onCompleted()


    }
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
}

