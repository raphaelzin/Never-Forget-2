//
//  SlideUp.swift
//  Never Forget
//
//  Created by Raphael Souza on 2016-10-05.
//  Copyright © 2016 com.raphael. All rights reserved.
//

import UIKit

class SlideUp: NSObject,UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {

    var reverse: Bool = false
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    let duration = 0.6
    func transitionDuration(using transitionContext:
        UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning)
    {
        let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from)!
        let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)!
        
        let container = transitionContext.containerView
        let offScreenUp = CGAffineTransform(translationX: 0, y: -container.frame.height)
        let offScreenDown = CGAffineTransform(translationX: 0, y: container.frame.height)
        
        // Make the toView off screen
        toView.transform = (reverse) ? offScreenUp : offScreenDown
        
        // Add both views to the container view
        container.addSubview(fromView)
        container.addSubview(toView)
        // Perform the animation
        
        UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping:
            0.8, initialSpringVelocity: 0.8, options: [], animations: {
                fromView.transform = (!self.reverse) ? offScreenUp : offScreenDown
                fromView.alpha = 1
                toView.transform = CGAffineTransform.identity
            }, completion: { finished in
                transitionContext.completeTransition(true)
        }) }
}
