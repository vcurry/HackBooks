//
//  PdfViewController.swift
//  HackBooks
//
//  Created by Verónica Cordobés on 4/7/16.
//  Copyright © 2016 Verónica Cordobés. All rights reserved.
//

import UIKit

class PdfViewController: UIViewController, UIWebViewDelegate {

    var model : Book
    
    @IBOutlet weak var pdfView: UIWebView!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    
    init(model: Book){
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func syncModelWithView(){
        pdfView.delegate = self
        activityView.startAnimating()

        
        let fileManager = NSFileManager.defaultManager()
        let diskPaths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory,
                                                            NSSearchPathDomainMask.UserDomainMask,
                                                            true)
        let cacheDirectory = NSURL(string: diskPaths[0] as String)
        let fileName = model.url.lastPathComponent
        let diskPath = cacheDirectory?.URLByAppendingPathComponent(fileName!)
        
        if fileManager.fileExistsAtPath("\(diskPath!)"){
            let pdfData = NSData(contentsOfFile: "\(diskPath!)")
            pdfView.loadData(pdfData!, MIMEType: "application/pdf", textEncodingName: "", baseURL: diskPath!)
        } else {
            let pdfData = NSData(contentsOfURL: model.url)!
            pdfData.writeToFile("\(diskPath!)", atomically: true)
            pdfView.loadRequest(NSURLRequest(URL: model.url))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let nc = NSNotificationCenter.defaultCenter()
        nc.addObserver(self, selector: #selector(bookDidChange), name: BookDidChangeNotification, object: nil)
        syncModelWithView()
    }

    func bookDidChange(notification: NSNotification){
        //Sacar el userInfo
        let info = notification.userInfo!
        //Saca el libro
        let book = info[BookKey] as? Book
        //Actualizar el modelo
        model = book!
        //Sincronizar las vistas
        syncModelWithView()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        //Baja en la notificación
        let nc = NSNotificationCenter.defaultCenter()
        nc.removeObserver(self)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    //MARK: - UIWebViewDelegate
    func webViewDidFinishLoad(webView: UIWebView) {
        
        //Parar el activity view
        activityView.stopAnimating()
        
        //Ocultarlo
        activityView.hidden = true
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if navigationType == .LinkClicked || navigationType == .FormSubmitted{
            return false
        } else {
            return true
        }
    }

}
