//
//  HUD.swift
//  Home
//
//  Created by Sebastien Villar on 10/24/18.
//  Copyright © 2018 -. All rights reserved.
//

import Foundation
import UIKit

class HUD {

  // MARK: - Public

  static func show(completion: (() -> Void)? = nil) {
    guard let delegate = UIApplication.shared.delegate, let window = delegate.window else {
      return
    }

    guard let rootVC = hudWindow.rootViewController, rootVC.presentedViewController == nil else {
      return
    }

    hudWindow.isHidden = false
    hudWindow.frame = window?.frame ?? .zero
    hudWindow.makeKeyAndVisible()
    rootVC.present(mainVC, animated: true, completion: completion)
  }

  static func hide(completion: (() -> Void)? = nil) {
    guard let delegate = UIApplication.shared.delegate, let window = delegate.window else {
      return
    }

    guard let rootVC = hudWindow.rootViewController, rootVC.presentedViewController != nil else {
      return
    }

    rootVC.dismiss(animated: true) {
      window?.makeKeyAndVisible()
      self.hudWindow.isHidden = true
      completion?()
    }
  }

  // MARK: - Private

  private static var hudWindow: UIWindow = {
    let window = UIWindow(frame: .zero)
    window.rootViewController = UIViewController()
    window.windowLevel = UIWindowLevelAlert
    return window
  }()

  private static let mainVC = HUDVC()
}

private struct Constants {
  static let animationDuration: TimeInterval = 0.2
  static let animationFromScale: CGFloat = 0.6
}

private class HUDVC: UIViewController, UIViewControllerTransitioningDelegate {

  init() {
    super.init(nibName: nil, bundle: nil)

    modalPresentationStyle = .custom
    transitioningDelegate = self
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func loadView() {
    view = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    (view as? UIActivityIndicatorView)?.startAnimating()
  }

  func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
    return HUDPresentationController(presentedViewController: presented, presenting: presenting)
  }

  func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return HUDAnimator(presenting: true)
  }

  func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return HUDAnimator(presenting: false)
  }
}

private class HUDAnimator: NSObject, UIViewControllerAnimatedTransitioning {
  init(presenting: Bool) {
    self.presenting = presenting
  }

  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return Constants.animationDuration
  }

  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    guard let view = transitionContext.view(forKey: presenting ? .to : .from), let vc = transitionContext.viewController(forKey: presenting ? .to : .from) else {
      assertionFailure("Missing view/vc")
      return
    }

    let fromScale: CGFloat = presenting ? Constants.animationFromScale : 1
    let toScale: CGFloat = presenting ? 1 : Constants.animationFromScale
    let fromAlpha: CGFloat = presenting ? 0 : 1
    let toAlpha: CGFloat = presenting ? 1 : 0

    view.frame = transitionContext.finalFrame(for: vc)
    view.transform = CGAffineTransform.identity.scaledBy(x: fromScale, y: fromScale)
    view.alpha = fromAlpha

    if presenting {
      transitionContext.containerView.addSubview(view)
    }

    UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .curveEaseOut, animations: {
      view.transform = CGAffineTransform.identity.scaledBy(x: toScale, y: toScale)
      view.alpha = toAlpha
    }) { _ in
      if !self.presenting {
        view.removeFromSuperview()
      }
      transitionContext.completeTransition(true)
    }
  }

  private let presenting: Bool
}

private class HUDPresentationController: UIPresentationController {
  override var frameOfPresentedViewInContainerView: CGRect {
    let containerSize = containerView?.frame.size ?? .zero
    let size = presentedView?.sizeThatFits(containerSize) ?? .zero
    return CGRect(
      x: (containerSize.width - size.width) / 2,
      y: (containerSize.height - size.height) / 2,
      width: size.width,
      height: size.height
    ).integral
  }

  override func presentationTransitionWillBegin() {
    dimmingView.backgroundColor = .backgroundDimming
    dimmingView.frame = containerView?.bounds ?? .zero
    dimmingView.alpha = 0
    containerView?.addSubview(dimmingView)
    presentedViewController.transitionCoordinator?.animate(alongsideTransition: { context in
      UIView.animate(withDuration: context.transitionDuration, delay: 0, options: .curveEaseOut, animations: {
        self.dimmingView.alpha = 1
      }, completion: nil)
    }, completion: nil)
  }

  override func dismissalTransitionWillBegin() {
    presentedViewController.transitionCoordinator?.animate(alongsideTransition: { context in
      UIView.animate(withDuration: context.transitionDuration, delay: 0, options: .curveEaseOut, animations: {
        self.dimmingView.alpha = 0
      }, completion: nil)
    }, completion: nil)
  }

  override func dismissalTransitionDidEnd(_ completed: Bool) {
    dimmingView.removeFromSuperview()
  }

  private let dimmingView = UIView()
}
