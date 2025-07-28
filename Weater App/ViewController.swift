//
//  ViewController.swift
//  Weater App
//
//  Created by Eder Junior Alves Silva on 27/07/25.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var customView: UIView = {
        let view = UIView(frame: .zero)
        
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    private func setupView() {
        view.backgroundColor = .red
        setHierarchy()
        setContraints()
      
      
    }
    
    private func setHierarchy() {
        view.addSubview(customView)
    }

    private func setContraints() {
           NSLayoutConstraint.activate([
               customView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
               customView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
               customView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
               customView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100)
           ])
       }
   }

