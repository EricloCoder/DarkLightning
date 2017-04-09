//
//  ViewController.swift
//  Messenger-iOS
//
//  Created by Jens Meder on 05.04.17.
//
//

import UIKit
import DarkLightning

class ViewController: UIViewController {
    
    private let textView: Memory<UITextView?>
    private let header: Memory<UINavigationItem?>

    init(title: String, textView: Memory<UITextView?>, header: Memory<UINavigationItem?>) {
        self.textView = textView
        self.header = header
        self.title = title
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        self.textView.rawValue = UITextView()
        self.view = self.textView.rawValue
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.header.rawValue = navigationItem
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.header.rawValue = nil
    }
}

