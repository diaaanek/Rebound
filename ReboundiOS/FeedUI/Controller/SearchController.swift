//
//  SearchController.swift
//  ReboundiOS
//
//  Created by Ethan Keiser on 3/10/22.
//

import UIKit

public class SearchController: UISearchController {

    public init(_ controller: UIViewController ,resultUpdate: UISearchResultsUpdating?) {
        super.init(searchResultsController: controller)
        self.searchResultsUpdater = resultUpdate
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    public override func viewDidLoad() {
        super.viewDidLoad()
      
    
        // Do any additional setup after loading the view.
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
