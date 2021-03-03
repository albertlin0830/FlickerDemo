import UIKit
import SDWebImage

class ResultVC: UIViewController {
    
    @IBOutlet weak var contentCollectionView: UICollectionView!
    
    var searchTxt:String!
    var photosModel:PhotosModel!
    var photos:[PhotoModel]!
    var current_page:Int = 1
    var total_page_count:Int = 0
    var isFirstGetData:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentCollectionView.delegate = self
        contentCollectionView.dataSource = self
        
        contentCollectionView.register(UINib.init(nibName: "PhotoCell", bundle: nil),
                                       forCellWithReuseIdentifier: "PhotoCell")
        
        total_page_count = photosModel.pages!
        self.refreshAndLoadMoreSetUp()
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

extension ResultVC {
    
    func refreshAndLoadMoreSetUp() {
        
        contentCollectionView.refreshControl = UIRefreshControl.init()
        
        contentCollectionView.refreshControl?.addTarget(self, action: #selector(self.refreshData), for: .valueChanged)
        self.enabledPull(toRefreshAndLoadMore: contentCollectionView)
        self.hasNextPage = total_page_count > currentPage ? true : false
    }
    
    @objc func refreshData() {

        self.getSearchData(isRefresh: true)
    }
    
    override func loadDatas() {
        
        self.getSearchData(isRefresh: false)
    }
    
    func getSearchData(isRefresh:Bool) {
        
        if current_page == total_page_count {
            
            return
        }
        var current:Int = 1
        
        if !isRefresh {
            
            current = current_page + 1
        }
        
        APIManager.shared.getPhotoData(search: searchTxt, per_page: "\(photosModel.perpage!)", currentPage: current, success: { (response) in
            
            let result:ResultModel = response as! ResultModel
            
            self.photosModel = result.photos!
            self.current_page = self.photosModel.page!
            self.total_page_count = self.photosModel.pages!
            self.hasNextPage = self.total_page_count > self.currentPage ? true : false
            
            if isRefresh {
                
                self.photos = self.photosModel.photo
                
            } else {
                
                self.photos.append(contentsOf: self.photosModel.photo)
            }
            
            DispatchQueue.main.async {
                
                self.contentCollectionView.reloadData()
                
                if isRefresh {
                    
                    self.contentCollectionView.refreshControl?.endRefreshing()
                    
                } else {
                    
                    self.endRefresh()
                }
            }
        })
    }
}
