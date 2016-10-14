//
//  CustomInteractionController.swift
//  Never Forget
//
//  Created by Raphael Souza on 2016-10-07.
//  Copyright © 2016 com.raphael. All rights reserved.
//

import UIKit

class CustomInteractionController: UIPercentDrivenInteractiveTransition {

    
    var navigationController: UINavigationController!
    var shouldCompleteTransition = false
    var transitionInProgress = false
    var completionSeed: CGFloat {
        return 1
    }
    
    func attachToViewController(viewController: UIViewController) {
        navigationController = viewController.navigationController
        setupGestureRecognizer(view: navigationController.navigationBar)
        setupGestureRecognizer(view: viewController.view)
    }
    
    private func setupGestureRecognizer(view: UIView) {
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(CustomInteractionController.handlePanGesture(gestureRecognizer:))))
    }
    
    func handlePanGesture(gestureRecognizer: UIPanGestureRecognizer) {
        let viewTranslation = gestureRecognizer.translation(in: gestureRecognizer.view!.superview!)
        
        switch gestureRecognizer.state {
        case .began:
            transitionInProgress = true
            navigationController.popViewController(animated: true)
        case .changed:
            let const = CGFloat(fminf(fmaxf(Float(viewTranslation.y / 400), 0.0), 1.0))
            shouldCompleteTransition = const > 0.5
            update(CGFloat(fminf(fmaxf(Float(viewTranslation.y / (UIScreen.main.bounds.height*2)), 0.0), 1.0)))
        case .cancelled, .ended:
            transitionInProgress = false
            if !shouldCompleteTransition || gestureRecognizer.state == .cancelled {
                
                cancel()
            } else {
                
                finish()
            }
        default:
            print("Swift switch must be exhaustive, thus the default")
        }
    }
    
}
