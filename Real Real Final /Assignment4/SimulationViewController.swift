//
//  FirstViewController.swift
//  
//

import UIKit

class SimulationViewController: UIViewController, GridViewDataSource, EngineDelegate {

    
    
    @IBOutlet weak var gridView: GridView!
    var engine: StandardEngine!

    override func viewDidLoad() {
    }
    
    override func viewWillAppear(_ animated: Bool) {
        engine = StandardEngine.engine
        gridView.workspaceSize = engine.rows
        gridView.gridDataSource = self
        engine.delagate = self
        
    }
    
    func engineDidUpdate(withGrid: GridProtocol) {
        self.gridView.setNeedsDisplay()
    }
    public subscript (row: Int, col: Int) -> CellState {
        get { return engine.grid[row,col] }
        set { engine.grid[row,col] = newValue }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func next(_ sender: Any) {
        engine.grid = self.engine.step()
        
    }
    @IBAction func didResetGrid(_ sender: UIButton) {
        for i in 0 ... StandardEngine.engine.rows {
            for j in 0 ... StandardEngine.engine.cols {
                StandardEngine.engine.grid[i,j] = .empty
        StandardEngine.engine.notifyDelageandPublishGrid()
        
            
        }
    }
        
    }
    
    
 

    
    
    
    

}

