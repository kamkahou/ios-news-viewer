//
//  WebViewController.swift
//  FinalHomework
//
//  Created by JoeJoe on 06/06/2021.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    var mWebView: WKWebView? = nil
    var path : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let url = path!
        loadURL(urlString: url)
        // Do any additional setup after loading the view.
    }
    
    private func loadURL(urlString: String)
    {
        let url = URL(string: urlString)
        if let url = url
        {
            let request = URLRequest(url: url)
            // init and load request in webview.
            mWebView = WKWebView(frame: self.view.frame)
            if let mWebView = mWebView
            {
                mWebView.navigationDelegate = self
                mWebView.load(request)
                self.view.addSubview(mWebView)
                self.view.sendSubviewToBack(mWebView)
            }
        }
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

extension WebViewController: WKNavigationDelegate
{
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error)
    {
        print(error.localizedDescription)
    }
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!)
    {
        print("Strat to load")
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!)
    {
        print("finish to load")
    }
}
