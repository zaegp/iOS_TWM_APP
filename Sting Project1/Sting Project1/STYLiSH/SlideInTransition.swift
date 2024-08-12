//
//  SlideInTransition.swift
//  STYLiSH
//
//  Created by 謝霆 on 2024/7/28.
//

import UIKit

class SlideInTransition: NSObject, UIViewControllerAnimatedTransitioning {
    let duration = 0.3
    var isPresenting = true

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView

        let toView = transitionContext.view(forKey: .to) ?? transitionContext.viewController(forKey: .to)!.view!
        let fromView = transitionContext.view(forKey: .from) ?? transitionContext.viewController(forKey: .from)!.view!

        let finalHeight = containerView.bounds.height - 120
        let finalWidth = containerView.bounds.width

        if isPresenting {
            toView.frame = CGRect(x: 0, y: containerView.frame.height, width: finalWidth, height: finalHeight + 120)
            containerView.addSubview(toView)

            UIView.animate(withDuration: duration, animations: {
                toView.frame = CGRect(x: 0, y: 0, width: finalWidth, height: finalHeight)
            }) { _ in
                transitionContext.completeTransition(true)
            }
        } else {
            UIView.animate(withDuration: duration, animations: {
                fromView.frame = CGRect(x: 0, y: containerView.frame.height, width: finalWidth, height: finalHeight + 120)
            }) { _ in
                fromView.removeFromSuperview()
                transitionContext.completeTransition(true)
            }
        }
    }
}




class TransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {
    let slideInTransition = SlideInTransition()
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        slideInTransition.isPresenting = true
        return slideInTransition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        slideInTransition.isPresenting = false
        return slideInTransition
    }
}
