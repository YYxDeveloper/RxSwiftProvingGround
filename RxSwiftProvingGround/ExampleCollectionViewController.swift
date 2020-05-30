//
//  ExampleCollectionViewController.swift
//  RxSwiftProvingGround
//
//  Created by Young Lu on 2020/5/29.
//  Copyright © 2020 呂子揚. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources
class ExampleCollectionViewController: UIViewController, UIScrollViewDelegate {
    let disposeBag = DisposeBag()

    @IBOutlet weak var collectionView: UICollectionView!
    let arr = [SectionItem(id: 0, title: "aa")]
    let sectionModels = BehaviorRelay<[SectionModel]>(value: [SectionModel(original: .end([SectionItem(id: 0, title: "aa")]), items: [SectionItem(id: 1, title: "gg")])])

    override func viewDidLoad() {
        super.viewDidLoad()
        sectionModels.bind(to: collectionView.rx.items(dataSource: createDataSource())).disposed(by: disposeBag)
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
    }
    

    @IBAction func click(_ sender: Any) {
//        sectionModels.accept( [SectionModel(original: .end([SectionItem(id: 0, title: "tt"),SectionItem(id: 0, title: "tt")]), items: [SectionItem(id: 1, title: "dd")])])
//        [SectionItem(id: 1, title: "dd")]
       
        sectionModels.accept([SectionModel(original: .group(2, "ii",  [SectionItem(id: 1, title: "uuuq")]), items: [SectionItem(id: 1, title: "uuru"),SectionItem(id: 1, title: "uuru")])])
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension ExampleCollectionViewController {
    func createDataSource() -> RxCollectionViewSectionedReloadDataSource<ExampleCollectionViewController.SectionModel> {
        return RxCollectionViewSectionedReloadDataSource.init(configureCell: { [weak self] (_, collectionView, indexPath, item) in
            guard let `self` = self else { fatalError() }
            return self.createCell(collectionView: collectionView, indexPath: indexPath, item: item)
            }, configureSupplementaryView: { [weak self] (_, collectionView, kind, indexPath) in
                guard let `self` = self else { fatalError() }
                
//                if kind == UICollectionView.elementKindSectionHeader {
//                    return self.createHeaderView(collectionView: collectionView, indexPath: indexPath)
//                } else if kind == UICollectionView.elementKindSectionFooter {
//                    return self.createFooterView(collectionView: collectionView, indexPath: indexPath)
//                } else {
//                    fatalError()
//                }
                return UICollectionReusableView()
        })
    }
    
     func createCell(collectionView: UICollectionView, indexPath: IndexPath, item: ExampleCollectionViewController.SectionItem) -> UICollectionViewCell {
          guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RxCollectionViewCell", for: indexPath) as? RxCollectionViewCell else {
              return collectionView.dequeueReusableCell(withReuseIdentifier: "RxCollectionViewCell", for: indexPath)
          }
        print(item.title)
          cell.label.text = item.title
          return cell
      }
    
}
extension ExampleCollectionViewController {
    enum SectionModel: SectionModelType {
        case group(Int, String, [SectionItem])
        case end([SectionItem])
        
        typealias Item = SectionItem
        var items: [SectionItem] {
            switch self {
            case .group(_, _, let items): return items
            case .end(let items): return items
            }
        }
        
        init(original: SectionModel, items: [SectionItem]) {
            switch original {
            case .group(let type, let title, _):
                self = .group(type, title, items)
                
            case .end:
                self = .end(items)
            }
        }
    }
    
    struct SectionItem {
        let id: Int
        let title: String
        var selectionType: SelectionType = .normal
    }
    
    enum SelectionType {
        case old
        case normal
        case selected
    }
}
