//
//  SecondViewController.swift


import UIKit

let finalProjectURL = "https://dl.dropboxusercontent.com/u/7544475/S65g.json"


var sectionHeaders = ["Configuration"]



var data = [[String]]()

var content = [[Any]]()




class InstrumentationViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate {
    
   
    
    @IBOutlet weak var insturmentationTableView: UITableView!
    
    @IBOutlet weak var addRowButton: UIButton!
    
  
    @IBOutlet weak var simulationStart: UISwitch!
    @IBOutlet weak var refreashLabel: UILabel!
    @IBOutlet weak var refreshSlider: UISlider!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var sizeSlider: UISlider!
    var eng : StandardEngine
    var newRefreashTime: Double = 1.0
    
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        
        
        engine = StandardEng.eng
        navigationController?.isNavigationBarHidden = true
    
        let fetcher = Fetcher()
        fetcher.fetchJSON(url: URL(string:finalProjectURL)!) { (json: Any?, message: String?) in
            guard message == nil else {
                print(message ?? "nil")
                return
            }
            guard let json = json else {
                print("no json")
                return
            }
                      let jsonArray = json as! Array<Any>
            
            
            //Create title and value
            for i in jsonArray {
                let t_dic =  i as! Dictionary<String, Any>
                let t_tit = t_dic["title"] as! String
                let t_val = t_dic["contents"] as NSMutableArray.Element
                data.append([t_tit])
                content.append([t_val])
            }
            
          let jsonDictionary = jsonArray[1] as! NSDictionary
          _ = jsonDictionary["title"] as! String
          _ = jsonDictionary["contents"] as! [[Int]]
           OperationQueue.main.addOperation {
            self.insturmentationTableView.reloadData()
            }
        }
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
  
    func showErrorAlert(withMessage msg:String, action: (() -> Void)? ) {
        let alert = UIAlertController(
            title: "Alert",
            message: msg,
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            alert.dismiss(animated: true) { }
            OperationQueue.main.addOperation { action?() }
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "basic"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        let label = cell.contentView.subviews.first as! UILabel
        label.text = data[indexPath.item][0]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionHeaders[0] //problem here with the name
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            var newData = data[indexPath.section]
            newData.remove(at: indexPath.row)
            data[indexPath.section] = newData
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.reloadData()
        }
    }
    

    
    
    
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            let indexPath = insturmentationTableView.indexPathForSelectedRow
            if let indexPath = indexPath {
                let gridName = data[indexPath.row][0]  //[indexPath.section]
                let contentGrid = content[indexPath.row][0] //[indexPath.section]
                if let vc = segue.destination as? GridEditorViewController {
                    vc.gridName = gridName
                    vc.contentGrid = (contentGrid as! NSArray)
                    vc.saveClosure = { newValue in
                        data[indexPath.row][0] = newValue  //[indexPath.section]
                        self.insturmentationTableView.reloadData()
                    vc.saveGridClosure = {newGridValue in content[indexPath.row][0] = newGridValue  //[indexPath.section]
                            self.insturmentationTableView.reloadData()
                    
                    
                }
            }
        }
            
    }
            
    }
    
  
    @IBAction func sizeSliderDidChange(_ sender: UISlider) {
        let currentVal = Int(sender.value)
        sizeLabel.text = "\(currentVal)"
        engine.changeEngineSize(size: currentVal)
        
    }
    
    @IBAction func refreashSliderDidChange(_ sender: UISlider) {
        let refreashcurrentVal = Int(sender.value)
        refreashLabel.text = "\(refreashcurrentVal)"
        newRefreashTime = Double(refreashcurrentVal)
                
    }
    
    
    
    @IBAction func simulationSwitchDidStart(_ sender: UISwitch) {
        if simulationStart.isOn {
            StandardEng.engine.refreshTimer = newRefreashTime
            print(StandardEng.engine.refreshTimer)
            StandardEng.engine.notifyDelageandPublishGrid()
            simulationStart.setOn(true, animated:true)
        } else {
             simulationStart.setOn(false, animated:true)
             StandardEng.engine.refreshTimer = 0.0
            
        }
    }
    
    
    @IBAction func addRowstoDataActions(_ sender: UIButton) {
        
        data.append(["Current Save"])
        let dummy = [[10,0]] as NSArray
        content.append([dummy])
        self.insturmentationTableView.reloadData()
        
        
        
    }
    
    
    }
    
    
    


