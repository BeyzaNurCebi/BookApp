//
//  ViewController.swift
//  BookApp
//
//  Created by Beyza Nur Çebi on 8.04.2020.
//  Copyright © 2020 Beyza Nur Çebi. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage

class HomeViewController: UIViewController{
    
    @IBOutlet weak var myView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var searchBar = UISearchBar()
    private var bookArray = [Item]()
    private var key = "&key=AIzaSyC8b2xxEd6xNZpP2P-UcZ9EqSFg8JeFO-A"
    private var url = "https://www.googleapis.com/books/v1/volumes?q="
    private var selectedBook: Item!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.myView.addShadow(shadowColor: UIColor(red: 1.00, green: 0.36, blue: 0.24, alpha: 1.00), offSet: CGSize(width: 2.6, height: 2.6), opacity: 0.8, shadowRadius: 5.0, cornerRadius: 47.0, corners: [.bottomLeft, .bottomRight], fillColor: UIColor(red: 1.00, green: 0.36, blue: 0.24, alpha: 1.00))
    
        labels(width: 200, y: 120, text: "Book App", ofSize: 30)
        labels(width: 300, y: 150, text: "Search all book here", ofSize: 17)
        configueUI()
        
    }
    
    
    
    private func fetchBooks(bookName: String) {
      // 1
      let request = AF.request("\(url)\(bookName)\(key)")
      // 2
      request.responseDecodable(of: Book.self) { (response) in
        if let books = response.value  {
            for book in books.items{
                //print(book)
                self.bookArray.append(book)
            }
        }
        self.collectionView.reloadData()
        
      }
        print("\(url)\(bookName)\(key)")
        print(bookArray)
    }
    
    
    @objc func handleShowSearchBar(){
        search(shouldShow: true)
        searchBar.becomeFirstResponder()
    }
    
    func configueUI(){
        searchBar.sizeToFit()
        searchBar.delegate = self
        
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.tintColor = .white
        
        
        
        if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
            textfield.backgroundColor = UIColor.white
            textfield.textColor = UIColor.black
        }
        showSearchBarButton(shouldShow: true)
        
    }
    
    func labels(width: Int,y: Int,text: String,ofSize: CGFloat){
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: width
            , height: 30))
        label.center = CGPoint(x: 207, y: y)
        label.textAlignment = .center
        label.text = text
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: ofSize)
        self.myView.addSubview(label)
    }
    
    func showSearchBarButton(shouldShow: Bool){
        if shouldShow{
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(handleShowSearchBar))
        }else {
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    func search(shouldShow: Bool){
        showSearchBarButton(shouldShow: !shouldShow)
        searchBar.showsCancelButton = shouldShow
        navigationItem.titleView = shouldShow ? searchBar: nil // this line exactly the same process with those down lines.
        
//        if shouldShow{
//            navigationItem.titleView = searchBar
//        } else {
//            navigationItem.titleView = nil
//        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToSearchedBookViewController"{
            let searchedBookVC = segue.destination as! SearchedBookViewController
            searchedBookVC.item = selectedBook
            
        }
    }

    
}
//MARK: - UIView
extension UIView {
    
    func addShadow(shadowColor: UIColor, offSet: CGSize, opacity: Float, shadowRadius: CGFloat, cornerRadius: CGFloat, corners: UIRectCorner, fillColor: UIColor = .white) {
        
        let shadowLayer = CAShapeLayer()
        let size = CGSize(width: cornerRadius, height: cornerRadius)
        let cgPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: size).cgPath //1
        shadowLayer.path = cgPath //2
        shadowLayer.fillColor = fillColor.cgColor //3
        shadowLayer.shadowColor = shadowColor.cgColor //4
        shadowLayer.shadowPath = cgPath
        shadowLayer.shadowOffset = offSet //5
        shadowLayer.shadowOpacity = opacity
        shadowLayer.shadowRadius = shadowRadius
        self.layer.addSublayer(shadowLayer)
    }
}

//MARK: - UISearchBarDelegate
extension HomeViewController: UISearchBarDelegate{
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        search(shouldShow: false)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            self.bookArray.removeAll(keepingCapacity: false)
            self.collectionView.reloadData()
            searchBar.resignFirstResponder()
        }else{
            self.bookArray.removeAll(keepingCapacity: false)
            self.fetchBooks(bookName: searchText.removeWhiteSpace())
        }
    }
}
//MARK: - UICollectionViewDelegate-UICollectionViewDataSource
extension HomeViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bookArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "goToSearchedBookViewController", for: indexPath) as! CollectionViewCell
        cell.imageView.sd_setImage(with: URL(string: bookArray[indexPath.row].volumeInfo.imageLinks.thumbnail))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedBook = bookArray[indexPath.row]
        performSegue(withIdentifier: "goToSearchedBookViewController", sender: self)
    }
    

}

extension String {
    func replace(string: String, replacement: String)->String{
        return self.replacingOccurrences(of: string, with: replacement, options: NSString.CompareOptions.literal, range: nil)
    }
    
    func removeWhiteSpace()->String{
        return self.replace(string: " ", replacement: "+")
    }
}
