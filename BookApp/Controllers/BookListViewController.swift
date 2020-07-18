//
//  BookListViewController.swift
//  BookApp
//
//  Created by Beyza Nur Çebi on 18.04.2020.
//  Copyright © 2020 Beyza Nur Çebi. All rights reserved.
//

import UIKit
import CoreData

class BookListViewController: UIViewController {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var tableView: UITableView!
    var readArray = [ReadBook]()
    var willReadArray = [WillReadBook]()
    
    var rowsToDisplay = [Any]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        


        let font = UIFont.systemFont(ofSize: 26)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
        
        _ = UIFont.systemFont(ofSize: 24)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .selected)
        
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 1.00, green: 0.36, blue: 0.24, alpha: 1.00)]
         segmentedControl.setTitleTextAttributes(titleTextAttributes, for: .normal)
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadBook()
        rowsToDisplay = readArray
        rowsToDisplay.reverse()
        self.reloadData()
    }
    
    func reloadData(){
        self.tableView.reloadData()
    }
    
    @IBAction func bookListChanged(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            rowsToDisplay.removeAll(keepingCapacity: false)
          for item in readArray{
            rowsToDisplay.append(item)
            
          }
            rowsToDisplay.reverse()
        case 1:
            rowsToDisplay.removeAll(keepingCapacity: false)
            for item in willReadArray{
                rowsToDisplay.append(item)
            }
            rowsToDisplay.reverse()
            
        default:
            for item in readArray{
                rowsToDisplay.append(item)
            }
            rowsToDisplay.reverse()
        }
        reloadData()
    }
    
    func loadBook() {
        let fetchRequestForReadArray: NSFetchRequest<ReadBook> = ReadBook.fetchRequest()
        let fetchRequestForWillReadArray: NSFetchRequest<WillReadBook> = WillReadBook.fetchRequest()
               do {
                   readArray = try context.fetch(fetchRequestForReadArray)
                    willReadArray = try context.fetch(fetchRequestForWillReadArray)
               } catch {
                   print("error")
               }
               tableView.reloadData()
           }
    }


extension BookListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowsToDisplay.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath) as! TableViewCell
        cell.titleLabel.text = (rowsToDisplay[indexPath.row] as AnyObject).title
        cell.bookImageView.image = UIImage(data: (rowsToDisplay[indexPath.row] as AnyObject).thumbnail!)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            context.delete(rowsToDisplay[indexPath.row] as! NSManagedObject)
            rowsToDisplay.remove(at: indexPath.row)
            do{
                try context.save()
            }catch {
                print(error)
            }
            tableView.reloadData()
        }
    }
}
