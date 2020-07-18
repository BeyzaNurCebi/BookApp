//
//  SearchedBookViewController.swift
//  BookApp
//
//  Created by Beyza Nur Çebi on 18.04.2020.
//  Copyright © 2020 Beyza Nur Çebi. All rights reserved.
//

import UIKit
import Cosmos
import Alamofire
import CoreData

class SearchedBookViewController: UIViewController {
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var bookNameLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var starView: CosmosView!
    
    @IBOutlet weak var readButton: UIButton!
    @IBOutlet weak var willReadButton: UIButton!
    
    
    var item: Item!
   
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        self.navigationController?.navigationBar.tintColor = UIColor(red: 1.00, green: 0.36, blue: 0.24, alpha: 1.00)
        
        favButton.layer.cornerRadius = 0.5 * favButton.bounds.size.width
        favButton.clipsToBounds = true
        
        
        bookNameLabel.numberOfLines = 0
        bookNameLabel.translatesAutoresizingMaskIntoConstraints = false
        bookNameLabel.lineBreakMode = .byWordWrapping
        
        
        authorLabel.numberOfLines = 0
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        authorLabel.lineBreakMode = .byWordWrapping
    
        
        readButton.makerRoundCornersButton(cornerRadius: 50, corners: [.bottomRight])
        willReadButton.makerRoundCornersButton(cornerRadius: 50, corners: [.bottomLeft])
        
        imageView.sd_setImage(with: URL(string: item.volumeInfo.imageLinks.thumbnail))
        bookNameLabel.text = item.volumeInfo.title
        authorLabel.text = "by "+item.volumeInfo.authors[0]
        descriptionTextView.text = item.volumeInfo.descriptions
        starView.rating = item.volumeInfo.averageRating ?? 2.0
        
        
        
    }
    
    
    @IBAction func readButtonPressed(_ sender: UIButton) {
        let searchedBook = ReadBook(context: context)
        searchedBook.title = item.volumeInfo.title
        searchedBook.authors = item.volumeInfo.authors[0]
        searchedBook.descriptions = item.volumeInfo.descriptions ?? "No Description"
        searchedBook.averageRating = item.volumeInfo.averageRating ?? 2.0
        let binaryData = imageView.image?.pngData()
        searchedBook.thumbnail = binaryData
        
        saveBook()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }
    
    
    @IBAction func willReadButtonPressed(_ sender: UIButton) {
        let searchedBook1 = WillReadBook(context: context)
        searchedBook1.title = item.volumeInfo.title
        searchedBook1.authors = item.volumeInfo.authors[0]
        searchedBook1.descriptions = item.volumeInfo.descriptions ?? "No Description"
        searchedBook1.averageRating = item.volumeInfo.averageRating ?? 2.0
        let binaryData1 = imageView.image?.pngData()
        searchedBook1.thumbnail = binaryData1
        
        saveBook()
    }
    
    //MARK: - Data Manipulation
    func saveBook() {
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
    
    

}
extension UIImageView {
    func makeRoundCornersView(cornerRadius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.bottomRight], cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = path.cgPath
        self.layer.mask = maskLayer
        
    }
}

extension UIButton {
    func makerRoundCornersButton(cornerRadius: CGFloat, corners: UIRectCorner) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = path.cgPath
        self.layer.mask = maskLayer
        
    }
}




