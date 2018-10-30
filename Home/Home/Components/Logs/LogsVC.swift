//
//  LogsVC.swift
//  Home
//
//  Created by Sebastien Villar on 10/19/18.
//  Copyright © 2018 -. All rights reserved.
//

import Foundation
import UIKit
import WebKit

class LogsVC: UIViewController {

  // MARK: - Public

  var onCancel: (() -> Void)?

  init(model: LogsModel) {
    // Prepare html
    self.html = {
      let headRegex = try! NSRegularExpression(pattern: "<head[^>]*>", options: .caseInsensitive)
      let headNSRange = headRegex.rangeOfFirstMatch(in: model.text, options: [], range: NSMakeRange(0, (model.text as NSString).length))
      guard let headRange = Range(headNSRange, in: model.text) else {
        assertionFailure("Missing head element")
        return model.text
      }

      let style = [
        "font-size: 14px",
        "word-wrap: break-word",
      ].joined(separator: ";")

      let headLastRange = headRange.upperBound..<headRange.upperBound
      var html = model.text
      html.replaceSubrange(headLastRange, with: "<style>\(style)</style>")
      return html
    }()

    super.init(nibName: nil, bundle: nil)

    navigationBarView.onCancel = { [weak self] in
      self?.onCancel?()
    }
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Super overrides

  override func viewDidLoad() {
    super.viewDidLoad()

    view.addSubview(navigationBarView)
    view.addSubview(webView)

    webView.loadHTMLString(html, baseURL: nil)
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()

    navigationBarView.sizeToFit()
    navigationBarView.frame = CGRect(
      x: 0,
      y: 0,
      width: view.width,
      height: navigationBarView.height
    )

    webView.frame = CGRect(
      x: 0,
      y: navigationBarView.bottom,
      width: view.width,
      height: view.height - navigationBarView.bottom
    )
  }

  // MARK: - Private

  private let navigationBarView = NavigationBarView()
  private let webView = WKWebView(frame: .zero)
  private let html: String
}
