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
    private var textField: UITextField?
    private var button: UIButton?
    private let header: Memory<UINavigationItem?>
    private let port: DarkLightning.Port

    init(title: String, textView: Memory<UITextView?>, header: Memory<UINavigationItem?>, port: DarkLightning.Port) {
        self.textView = textView
        self.header = header
        self.port = port
        super.init(nibName: nil, bundle: nil)
        self.title = title
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        let container = UIView()
        button = UIButton()
        button?.addTarget(self, action: #selector(send(button:)), for: .touchUpInside)
        button?.setTitle("Send", for: .normal)
        textField = UITextField()
        textField?.addTarget(self, action: #selector(textDidChange(textField:)), for: .editingChanged)
        textField?.backgroundColor = UIColor.white
        textView.rawValue = UITextView()
        textView.rawValue?.isEditable = false
        textView.rawValue?.translatesAutoresizingMaskIntoConstraints = false
        textField?.translatesAutoresizingMaskIntoConstraints = false
        button?.translatesAutoresizingMaskIntoConstraints = false
        button?.setContentHuggingPriority(UILayoutPriorityRequired, for: .horizontal)
        textField?.setContentHuggingPriority(UILayoutPriorityDefaultLow, for: .horizontal)
        container.addSubview(textView.rawValue!)
        container.addSubview(textField!)
        container.addSubview(button!)
        let constraints = [
            textView.rawValue?.topAnchor.constraint(equalTo: container.topAnchor),
            textView.rawValue?.bottomAnchor.constraint(equalTo: textField!.topAnchor),
            textView.rawValue?.leftAnchor.constraint(equalTo: container.leftAnchor),
            textView.rawValue?.rightAnchor.constraint(equalTo: container.rightAnchor),
            textField?.leftAnchor.constraint(equalTo: container.leftAnchor),
            textField?.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            button!.leftAnchor.constraint(equalTo: textField!.rightAnchor),
            button!.rightAnchor.constraint(equalTo: container.rightAnchor),
            button!.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            button!.heightAnchor.constraint(equalTo: textField!.heightAnchor)
        ]
        for constraint in constraints {
            constraint?.isActive = true
        }
        self.view = container
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.header.rawValue = navigationItem
        button?.isEnabled = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.header.rawValue = nil
    }
    
    // MARK: Text Field Events
    
    @objc private func textDidChange(textField: UITextField) {
        if textField.text!.isEmpty {
            button?.isEnabled = false
        }
        else {
            button?.isEnabled = true
        }
    }
    
    @objc private func send(button: UIButton) {
        textField?.text = nil
        button.isEnabled = false
        port.write(data: textField!.text!.data(using: .utf8)!)
    }
}

