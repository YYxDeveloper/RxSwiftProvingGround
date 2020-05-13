//
//  RxCollectionExViewController.swift
//  RxSwiftProvingGround
//
//  Created by Young Lu on 2020/5/13.
//  Copyright © 2020 呂子揚. All rights reserved.
//
//RxCollectionExViewController
import UIKit
import RxCocoa
import RxSwift
import RxDataSources
class CountryCell : UICollectionViewCell {
    @IBOutlet var countryLabel: UILabel?
}

class CountrySectionView : UICollectionReusableView {
    @IBOutlet weak var countrySectionLabel: UILabel?
}

class RxCollectionExViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    let disposeBag = DisposeBag()


    override func viewDidLoad() {
        super.viewDidLoad()
        let (cell, section) = RxCollectionExViewController.collectionViewDataSourceUI()
        let dataSource = RxCollectionViewSectionedReloadDataSource(configureCell: cell,
                                                                   configureSupplementaryView: section)

        let dummyData = [
            CountrySection(header: "Europe", countries: ["Germany", "Czech Republic", "Austria", "France"]),
            CountrySection(header: "Asia", countries: ["Vietnam", "Thailand", "Malaysia"])
            ]

        Observable.just(dummyData)
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }


}

extension RxCollectionExViewController {

    static func collectionViewDataSourceUI() -> (
        CollectionViewSectionedDataSource<CountrySection>.ConfigureCell,
        CollectionViewSectionedDataSource<CountrySection>.ConfigureSupplementaryView
        ) {
            return (
                { (_, cv, ip, i) in
                    let cell = cv.dequeueReusableCell(withReuseIdentifier: "Cell", for: ip) as! CountryCell
                    cell.countryLabel!.text = "\(i)"
                    return cell

            },
                { (ds ,cv, kind, ip) in
                    let section = cv.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Section", for: ip) as! CountrySectionView
                    section.countrySectionLabel!.text = "\(ds[ip.section].header)"
                    return section
            }
            )
    }

}

