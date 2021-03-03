import UIKit
import SDWebImage

class ResultVC: UIViewController {
    
    @IBOutlet weak var contentCollectionView: UICollectionView!
    
    var photosModel:PhotosModel!
    var photos:[PhotoModel]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentCollectionView.delegate = self
        contentCollectionView.dataSource = self
        
        contentCollectionView.register(UINib.init(nibName: "PhotoCell", bundle: nil),
                                       forCellWithReuseIdentifier: "PhotoCell")
        // Do any additional setup after loading the view.
    }
}

extension ResultVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath)
        
        if let contentCell = cell as? PhotoCell {
         
            let photo = photos[indexPath.row] as PhotoModel
            let imgUrl = "https://live.staticflickr.com/\(photo.server!)/\(photo.id!)_\(photo.secret!)_q.jpg"

            contentCell.content_LBL.text = photo.title
            contentCell.content_LBL.adjustsFontSizeToFitWidth = true
            contentCell.content_IMG.sd_setImage(with: URL(string: imgUrl), placeholderImage: nil)
        }
        
        return cell
    }

    // MARK: 設定牌卡layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let ScreenWidth: CGFloat = UIScreen.main.bounds.size.width
        let cellWidh = (ScreenWidth * 0.9 - 10) / 2
        let cellHeight = cellWidh * 5 / 4
        
        return CGSize(width: cellWidh, height: cellHeight)
    }
}
