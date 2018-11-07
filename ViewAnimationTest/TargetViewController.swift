//
//  TargetViewController.swift
//  ViewAnimationTest
//
//  Created by SEUNG-WON KIM on 2018/11/02.
//  Copyright © 2018 SEUNG-WON KIM. All rights reserved.
//

import Foundation
import UIKit

class TargetViewController: UIViewController {
  
  let tapView: UIView = {
    let v = UIView()
    v.translatesAutoresizingMaskIntoConstraints = false
    v.backgroundColor = .white
    return v
  }()
  
  let contantView: UIView = {
    let v = UIView()
    v.translatesAutoresizingMaskIntoConstraints = false
    v.backgroundColor = .red
    return v
  }()
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupView()
    setupLayout()
  }
}


extension TargetViewController {
  func setupView() {
    
    // addSubview
    view.addSubview(tapView)
    view.addSubview(contantView)
  
    
    let v = UIView()
    v.translatesAutoresizingMaskIntoConstraints = false
    v.backgroundColor = UIColor.lightGray
    tapView.addSubview(v)
    
    NSLayoutConstraint.activate([
      v.topAnchor.constraint(equalTo: tapView.topAnchor, constant: 10),
      v.centerXAnchor.constraint(equalTo: tapView.centerXAnchor),
      v.widthAnchor.constraint(equalToConstant: 45),
      v.heightAnchor.constraint(equalToConstant: 8)
      ])
    
  }
  
  func setupLayout() {
    
    // layout
    NSLayoutConstraint.activate([
      tapView.topAnchor.constraint(equalTo: view.topAnchor),
      tapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      tapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      tapView.heightAnchor.constraint(equalToConstant: 45)
      ])
    
    NSLayoutConstraint.activate([
      contantView.topAnchor.constraint(equalTo: tapView.bottomAnchor),
      contantView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      contantView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      contantView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
      ])
  }
}
