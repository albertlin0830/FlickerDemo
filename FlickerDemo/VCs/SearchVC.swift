import UIKit

class SearchVC: UIViewController {

    @IBOutlet weak var search_TXT: UITextField!
    @IBOutlet weak var cnt_TXT: UITextField!
    @IBOutlet weak var search_BTN: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initTxtStatus()
        self.setBtnStatus(isEnable: false)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func doSearch(_ sender: Any) {
        
        self.performSegue(withIdentifier: "goResult", sender: self)
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

