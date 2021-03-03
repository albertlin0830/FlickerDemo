import UIKit

class SearchVC: UIViewController {

    @IBOutlet weak var search_TXT: UITextField!
    @IBOutlet weak var cnt_TXT: UITextField!
    @IBOutlet weak var search_BTN: UIButton!
    
    var photosModel:PhotosModel!
    var photos:[PhotoModel]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initTxtStatus()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        self.search_TXT.text = ""
        self.cnt_TXT.text = ""
        self.setBtnStatus(isEnable: false)
    }
    
    @IBAction func doSearch(_ sender: Any) {
        
        let text = self.search_TXT.text!
        let per_page = self.cnt_TXT.text!

        APIManager.shared.getPhotoData(search:text,
                                    per_page:per_page,
                                    currentPage:1,
                                    success: { (response) in
                                        
                                        let result:ResultModel = response as! ResultModel
                                        self.photosModel = result.photos!
                                        self.photos = self.photosModel.photo
                                        
                                        if(self.photos.count > 0) {
                                            
                                            DispatchQueue.main.async {
                                                self.performSegue(withIdentifier: "goResult", sender: self)
                                            }
                                        }
                                    })
    }
}

extension SearchVC {
 
    func initTxtStatus() -> Void {
        
        self.search_TXT.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        
        self.cnt_TXT.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
    }
    
    func setBtnStatus(isEnable:Bool) -> Void {
        
        self.search_BTN.isEnabled = isEnable
        
        if isEnable {
            
            self.search_BTN.backgroundColor = .blue
            
        } else {
            
            self.search_BTN.backgroundColor = .gray
        }
    }
}

extension SearchVC:UITextFieldDelegate {
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let search = self.search_TXT.text else {
            return
        }
        
        guard let count = self.cnt_TXT.text else {
            return
        }
        
        if search.isEmpty || count.isEmpty {

            self.setBtnStatus(isEnable: false)
            
        } else {

            self.setBtnStatus(isEnable: true)
        }
    }
}

extension SearchVC {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if "goResult" == segue.identifier {
            
            let resultVC:ResultVC = segue.destination as! ResultVC
            
            resultVC.photosModel = photosModel
            resultVC.photos = photos
        }
    }
}
