//
//  FavNewsTableViewController.swift
//  FinalHomework
//
//  Created by JoeJoe on 06/06/2021.
//

import UIKit

protocol ShowNumDelegate {
    func showNum()
}

class FavNewsTableViewController: UITableViewController, ShowNumDelegate {
    
    var searchController:UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showNum()
        initSearch()
    }
    
    func showNum(){
        let queryResult = FavNewsTableViewController.readDB()
        if let root = UIApplication.shared.windows[0].rootViewController as? UITabBarController
                {
            root.viewControllers?[1].tabBarItem.badgeValue = "\(queryResult?.count ?? 0)"
            print(queryResult?.count ?? 0)
            
        }
    }
    
    static func readDB() -> [[String : AnyObject]]?
    {
        let sqlite = SQLiteManager.shareinstance
        if !sqlite.openDB(){ return nil }
        let queryResult = sqlite.execQuerySQL(sql: "SELECT * FROM news")
        sqlite.closeDB()
        
        return queryResult
    }
    
    // MARK: - Search
    
    func initSearch(){
        let resultsController = SearchResultTableViewController()
        resultsController.allNews = favNews!
        
        searchController = UISearchController(searchResultsController: resultsController)
        
        let searchBar = searchController.searchBar
        searchBar.placeholder = "Enter a search item"
        searchBar.sizeToFit()
        tableView.tableHeaderView = searchBar
        searchController.searchResultsUpdater = resultsController
        self.definesPresentationContext = true
    }
    
    var favNews = FavNewsTableViewController.readDB()
    
    override func viewWillAppear(_ animated: Bool) {
        favNews = FavNewsTableViewController.readDB()
        tableView.reloadData()
        showNum()
    }
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return favNews!.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favNewsCell", for: indexPath) as! FavNewsTableViewCell
        
        cell.favTitleLable.text = favNews![indexPath.row]["title"] as? String
        cell.favPasstimeLable.text = favNews![indexPath.row]["passtime"] as? String
        let imgUrl = favNews![indexPath.row]["image"] as? String
        cell.favNewsImage.downloadAsyncFrom(url: imgUrl!)

        return cell
    }
    
    static func DeleteNews(idI:Int)
    {
        let sqlite = SQLiteManager.shareinstance
        
        if !sqlite.openDB(){return}
        
        let deleteNews = "DELETE FROM news WHERE id = \(idI)"
        if !sqlite.execNoneQuerySQL(sql: deleteNews)
        {
            sqlite.closeDB();
            return
        }
        sqlite.closeDB();
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
          {
        let id = favNews![indexPath.row]["id"] as? Int
        
        let favAction = UIContextualAction(style: .destructive, title: "删除") { [self] (action, sourceView, complete) in
            FavNewsTableViewController.DeleteNews(idI: id!)
            favNews = FavNewsTableViewController.readDB()
            tableView.reloadData()
            showNum()

              complete(true)
              }
              let trailingSwipConfiguration = UISwipeActionsConfiguration(actions: [favAction])
              return trailingSwipConfiguration
          }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if let dest = segue.destination as? WebViewController
        {
            dest.path = favNews![ tableView.indexPathForSelectedRow!.row]["path"] as? String
        }
    }
}
