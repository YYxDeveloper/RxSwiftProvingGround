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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
    }
    func exampleObservableBindUI()  {
        timer.map{ String(format: "%0.2d:%0.2d.%0.1d",
                          arguments: [($0 / 600) % 600, ($0 % 600 ) / 10, $0 % 10]) }
            .bind(to: redLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
}

