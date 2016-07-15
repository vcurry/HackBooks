//
//  BookViewController.swift
//  HackBooks
//
//  Created by Verónica Cordobés on 2/7/16.
//  Copyright © 2016 Verónica Cordobés. All rights reserved.
//

import UIKit


class BookViewController: UIViewController {

    var model : Book
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tagsLabel: UILabel!
    @IBOutlet weak var authorsLabel: UILabel!
    @IBOutlet weak var imagen: UIImageView!
    
    init(model: Book) {

        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
       
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func showPdf(sender: AnyObject) {
        let pdfVC = PdfViewController(model: model)
        navigationController?.pushViewController(pdfVC, animated: true)
    }

    @IBAction func isFavorito(sender: AnyObject) {
     
        self.model.isFavoriteBook()

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        syncModelWithView()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
    func syncModelWithView(){
        titleLabel.text = model.title
        authorsLabel.text = model.authors.componentsJoinedByString(" - ")
        tagsLabel.text = model.tags.componentsJoinedByString(", ")
        
        let fileManager = NSFileManager.defaultManager()
        let diskPaths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory,
                                                            NSSearchPathDomainMask.UserDomainMask,
                                                            true)
        let cacheDirectory = NSURL(string: diskPaths[0] as String)
        let fileName = model.image.lastPathComponent
        let diskPath = cacheDirectory?.URLByAppendingPathComponent(fileName!)
        
        if fileManager.fileExistsAtPath("\(diskPath!)"){
            imagen.image = UIImage(data: NSData(contentsOfFile: "\(diskPath!)")!)
        } else {
            let imageData = NSData(contentsOfURL: model.image)!
            imagen.image = UIImage(data: imageData)
            imageData.writeToFile("\(diskPath!)", atomically: true)
            print(diskPath)
            imagen.image = UIImage(data: imageData)
        }
    }
}

extension BookViewController: LibraryViewControllerDelegate{
    func libraryViewController(vc: LibraryViewController, didSelectBook bk: Book) {
        model = bk
        
        syncModelWithView()
    }
}