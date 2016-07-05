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
        pdfView.loadRequest(NSURLRequest(URL: model.url))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
