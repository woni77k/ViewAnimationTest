//
//  ViewController.swift
//  ViewAnimationTest
//
//  Created by SEUNG-WON KIM on 2018/11/02.
//  Copyright © 2018 SEUNG-WON KIM. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

  enum TargetState {
    case expanded
    case collapsed
  }
  
  var targetViewController: TargetViewController!
  var visualEffectView: UIVisualEffectView!
  
  let targetheight: CGFloat = 600
  let handleAreaheight: CGFloat = 65
  
  var targetVisible = false
  var nextState: TargetState {
    return targetVisible ? .collapsed : .expanded
  }
  
  var runningAnimations = [UIViewPropertyAnimator]()
  var animationProgressWhenInterrupted: CGFloat = 0.0
  
  let bgImageView: UIImageView = {
    let iv = UIImageView(image: UIImage(named: "effielTower"))
    iv.translatesAutoresizingMaskIntoConstraints = false
    iv.contentMode = .scaleAspectFill
    return iv
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    setupViews()
    setupLayout()
    setupTarget()
  }

}

extension MainViewController {
  func setupTarget() {
    visualEffectView = UIVisualEffectView()
    visualEffectView.frame = self.view.frame
    self.view.addSubview(visualEffectView)
    
    targetViewController = TargetViewController()
    self.addChild(targetViewController)
    self.view.addSubview(targetViewController.view)
    
    targetViewController.view.frame = CGRect(x: 0, y: self.view.frame.height - handleAreaheight, width: self.view.bounds.width, height: targetheight)
    
    targetViewController.view.clipsToBounds = true
    
    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTargetTab))
    let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleTargetPan))
    
    targetViewController.tapView.addGestureRecognizer(tapGestureRecognizer)
    targetViewController.tapView.addGestureRecognizer(panGestureRecognizer)
  }
  
  @objc func handleTargetTab(recognizer: UITapGestureRecognizer) {
    switch recognizer.state {
    case .ended:
      animationTransitionIfNeeded(state: nextState, duration: 0.9)
    default:
      break
    }
  }
  
  @objc func handleTargetPan(recognizer: UIPanGestureRecognizer) {
    switch recognizer.state {
    case .began:
      startInteractiveTransition(state: nextState, duration: 0.9)
    case .changed:
      let translation = recognizer.translation(in: self.targetViewController.tapView)
      var fractionComplete = translation.y / targetheight
      fractionComplete = targetVisible ? fractionComplete : -fractionComplete
      updateInteractiveTransition(fractionCompleted: CFloat(fractionComplete))
    case .ended:
      continuIntractiveTransition()
    default:
      break
    }
  }
  
  func animationTransitionIfNeeded(state: TargetState, duration: TimeInterval) {
    if runningAnimations.isEmpty {
      let frameAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
        switch state {
        case .expanded:
          self.targetViewController.view.frame.origin.y = self.view.frame.height - self.targetheight
        case .collapsed:
          self.targetViewController.view.frame.origin.y = self.view.frame.height - self.handleAreaheight
        }
      }
      
      frameAnimator.addCompletion { (_) in
        self.targetVisible = !self.targetVisible
        self.runningAnimations.removeAll()
      }
      
      frameAnimator.startAnimation()
      runningAnimations.append(frameAnimator)
      
      let cornerRadiusAnimator = UIViewPropertyAnimator(duration: duration, curve: .linear) {
        switch state {
        case .expanded:
          self.targetViewController.view.layer.cornerRadius = 12
        case .collapsed:
          self.targetViewController.view.layer.cornerRadius = 0
        }
      }
      
      cornerRadiusAnimator.startAnimation()
      runningAnimations.append(cornerRadiusAnimator)
      
      
      let blurAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
        switch state {
        case .expanded:
          self.visualEffectView.effect = UIBlurEffect(style: .dark)
        case .collapsed:
          self.visualEffectView.effect = nil
        }
      }
      
      blurAnimator.startAnimation()
      runningAnimations.append(blurAnimator)
    }
  }
  
  func startInteractiveTransition(state: TargetState, duration: TimeInterval) {
    if runningAnimations.isEmpty {
      animationTransitionIfNeeded(state: state, duration: duration)
    }
    
    for animator in runningAnimations {
      animator.pauseAnimation()
      animationProgressWhenInterrupted = animator.fractionComplete
    }
  }
  
  func updateInteractiveTransition(fractionCompleted: CFloat) {
    for animator in runningAnimations {
      animator.fractionComplete = CGFloat(fractionCompleted) + animationProgressWhenInterrupted
    }
  }
  
  func continuIntractiveTransition() {
    for animator in runningAnimations {
      animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
    }
  }
}

extension MainViewController {
  func setupViews() {
    view.addSubview(bgImageView)
  }
  
  func setupLayout() {
    
    NSLayoutConstraint.activate([
      bgImageView.topAnchor.constraint(equalTo: view.topAnchor),
      bgImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      bgImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      bgImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
      ])
  }
}


