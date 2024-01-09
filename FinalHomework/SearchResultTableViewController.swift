//
//  SearchResultTableViewController.swift
//  S08
//
//  Created by JoeJoe on 21/04/2021.
//

import UIKit

class SearchResultTableViewController: UITableViewController, UISearchResultsUpdating {

    var allNews:[[String:AnyObject]] = []
    var filterNews:[[String:AnyObject]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "resultNews")
    }
    
    static func readDB(searchWord:String) -> [[String : AnyObject]]?
    {
        let sqlite = SQLiteManager.shareinstance
        if !sqlite.openDB(){ return nil }
        let queryResult = sqlite.execQuerySQL(sql:  "SELECT * FROM news WHERE title like '%\(searchWord)%'")
        sqlite.closeDB()
        
        return queryResult
    }
    
    func updateSearchResults(for searchController: UISearchController)
    {
        guard let searchString = searchController.searchBar.text else{return}
        if searchString.isEmpty{return}
        filterNews = SearchResultTableViewController.readDB(searchWord: searchString)!
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return filterNews.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "resultNews", for: indexPath)
        cell.textLabel!.text = filterNews[indexPath.row]["title"] as? String

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let mainstoryboard = UIStoryboard(name:"Main",bundle:nil)
            let detailVC = mainstoryboard.instantiateViewController(withIdentifier: "NewsDetailVC") as! WebViewController
            let nav = self.presentingViewController?.navigationController
            detailVC.path = filterNews[indexPath.row]["path"] as? String
            nav?.pushViewController(detailVC, animated: true)
    }

}
