//
//  ThermostatTemperatureAdjustmentView.swift
//  Home
//
//  Created by Sebastien Villar on 04/04/2018.
//  Copyright © 2018 -. All rights reserved.
//

import Foundation
import UIKit

class ThermostatTemperatureAdjustmentView: UIView {

  // MARK: - Public

  init(selectionHandler: @escaping (_ temperature: CGFloat) -> Void) {
    self.selectionHandler = selectionHandler

    super.init(frame: .zero)

    addSubview(scrollView)
    scrollView.delegate = self
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func setup(with viewModel: ThermostatTemperatureAdjustmentViewModel) {
    self.viewModel = viewModel

    if cells.isEmpty {
      // Setup views
      cells = viewModel.temperatures.enumerated().map { (index, text) in
        let borderStyle: Cell.BorderStyle = {
          if index == 0 {
            return .right
          }
          else if index == viewModel.temperatures.count - 1 {
            return .left
          }
          return .both
        }()

        return Cell(text: text, borderStyle: borderStyle)
      }
      cells.forEach { scrollView.addSubview($0) }
    }


    let oldSelectedIndex = selectedIndex
    selectedIndex = viewModel.selectedTemperatureIndex ?? 0
    needsSelection = oldSelectedIndex != selectedIndex

    setNeedsLayout()
  }

  // MARK: - Super overrides

  override func layoutSubviews() {
    super.layoutSubviews()

    guard cells.count >= 2 else {
      return
    }

    // ScrollView
    if scrollView.width != width || scrollView.height != height {
      // Bouncing of the scrollView changes the bounds. Do not override it
      scrollView.frame = bounds
    }

    scrollView.contentSize = CGSize(
      width: CGFloat(cells.count) * Cell.Constants.minWidth,
      height: height
    )

    scrollView.contentInset = UIEdgeInsets(
      top: 0,
      left: (width - Cell.Constants.minWidth) / 2,
      bottom: 0,
      right: (width - Cell.Constants.minWidth) / 2
    )

    if needsSelection, let selectedIndex = selectedIndex {
      needsSelection = false
      scrollView.contentOffset = contentOffset(for: selectedIndex)
    }

    // Center of the view in scrollView coordinates
    let centerX = scrollView.contentOffset.x + scrollView.width / 2

    // Cell index for the center of the view. Example: 2.4 -> 2.4 cells before the center
    // When the cell is exactly centered on the center, this number is an integer
    let centerIndex = (centerX - Cell.Constants.minWidth / 2) / Cell.Constants.minWidth
    let originalCentersX = cells.enumerated().map { Cell.Constants.minWidth / 2 + CGFloat($0.offset) * Cell.Constants.minWidth }
    let maxHalfScale = (Cell.Constants.maxWidth - Cell.Constants.minWidth) / 2

    // Frame cells
    cells.enumerated().forEach { (index, cell) in
      let originalCenterX = originalCentersX[index]
      var x = originalCenterX

      // Cells on each direction to the scaled ones should be moved further away by the amount of the scale on each side
      let offsetRatio = max(-1, min(1, centerIndex - CGFloat(index)))
      x -= offsetRatio * maxHalfScale

      // Scaling ratio is derived from offset
      cell.scalingRatio = 1 - abs(offsetRatio)
      let cellSize = cell.sizeThatFits(scrollView.frame.size)
      cell.frame = CGRect(
        x: x - cellSize.width / 2,
        y: 0,
        width: cellSize.width,
        height: cellSize.height
      )
    }
  }

  override func sizeThatFits(_ size: CGSize) -> CGSize {
    return CGSize(width: size.width, height: Cell.Constants.height)
  }

  // MARK: - Private

  private let scrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.alwaysBounceVertical = false
    scrollView.bounces = true
    scrollView.showsHorizontalScrollIndicator = false
    return scrollView
  }()

  private var viewModel: ThermostatTemperatureAdjustmentViewModel?
  private let selectionHandler: (_ temperature: CGFloat) -> Void
  private var selectedIndex: Int?
  private var cells = [Cell]()
  private var needsSelection = false

  private func contentOffset(for index: Int) -> CGPoint {
    return CGPoint(
      x: CGFloat(index) * Cell.Constants.minWidth - scrollView.contentInset.left,
      y: 0
    )
  }

  private func closestCenterIndex(for contentOffset: CGPoint) -> Int? {
    let targetPointX = contentOffset.x + width / 2
    let centersX = cells.enumerated().map { Cell.Constants.minWidth / 2 + CGFloat($0.offset) * Cell.Constants.minWidth }
    let sortedCentersX = centersX.sorted { abs($0 - targetPointX) < abs($1 - targetPointX) }
    guard let closestCenter = sortedCentersX.first, let closestCenterIndex = centersX.index(of: closestCenter) else {
      return nil
    }

    return closestCenterIndex
  }
}

extension ThermostatTemperatureAdjustmentView: UIScrollViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    setNeedsLayout()
  }

  func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
    guard let centerIndex = closestCenterIndex(for: targetContentOffset.pointee) else {
      return
    }

    targetContentOffset.pointee = contentOffset(for: centerIndex)
  }

  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    guard let centerIndex = closestCenterIndex(for: scrollView.contentOffset) else {
      return
    }

    selectedIndex = centerIndex

    if let viewModel = viewModel, let selectedIndex = selectedIndex {
      let temperature = viewModel.temperatureValues[selectedIndex]
      selectionHandler(CGFloat(temperature))
    }
  }
}

private class Cell: UIView {

  struct Constants {
    static let minWidth: CGFloat = 65
    static let maxWidth: CGFloat = 120
    static let height: CGFloat = 50

    static let minFont = UIFont.interUI(size: 20, weight: .regular)
    static let maxFont = UIFont.interUI(size: 40, weight: .regular)

    static let minColor = UIColor.foregroundGray
    static let maxColor = UIColor.foregroundWhite
  }

  // MARK: - Public

  enum BorderStyle {
    case both
    case left
    case right
  }

  var scalingRatio: CGFloat = 0 {
    didSet {
      setupSubviews()
      setNeedsLayout()
    }
  }

  init(text: String, borderStyle: BorderStyle) {
    label.text = text

    super.init(frame: .zero)

    switch borderStyle {
    case .both:
      break
    case .left:
      rightBorder.isHidden = true
    case .right:
      leftBorder.isHidden = true
    }

    addSubview(label)
    addSubview(leftBorder)
    addSubview(rightBorder)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Super overrides

  override func sizeThatFits(_ size: CGSize) -> CGSize {
    return CGSize(
      width: Constants.minWidth + (Constants.maxWidth - Constants.minWidth) * scalingRatio,
      height: Constants.height
    )
  }

  override func layoutSubviews() {
    super.layoutSubviews()

    leftBorder.frame = CGRect(
      x: 0,
      y: 0,
      width: 0.5,
      height: height
    )

    rightBorder.frame = CGRect(
      x: width - 0.5,
      y: 0,
      width: 0.5,
      height: height
    )

    label.sizeToFit()
    label.frame = CGRect(
      x: (width - label.width) / 2 + 3, // Magic number so number looks centered (but proportional to scaling ratio)
      y: (height - label.height) / 2,
      width: label.width,
      height: label.height
    ).integral
  }

  // MARK: - Private

  private let label = UILabel()

  private let leftBorder: UIView = {
    let view = UIView()
    view.backgroundColor = UIColor.foregroundLightGray
    return view
  }()

  private let rightBorder: UIView = {
    let view = UIView()
    view.backgroundColor = UIColor.foregroundLightGray
    return view
  }()

  // MARK: Helpers

  func setupSubviews() {
    label.textColor = color(from: Constants.minColor, toColor: Constants.maxColor, ratio: scalingRatio)
    label.font = font(from: Constants.minFont, toFont: Constants.maxFont, ratio: scalingRatio)
  }

  private func color(from fromColor: UIColor, toColor: UIColor, ratio: CGFloat) -> UIColor {
    var fromRed: CGFloat = 0
    var fromBlue: CGFloat = 0
    var fromGreen: CGFloat = 0
    fromColor.getRed(&fromRed, green: &fromGreen, blue: &fromBlue, alpha: nil)

    var toRed: CGFloat = 0
    var toBlue: CGFloat = 0
    var toGreen: CGFloat = 0
    toColor.getRed(&toRed, green: &toGreen, blue: &toBlue, alpha: nil)

    return UIColor(
      red: fromRed + (toRed - fromRed) * ratio,
      green: fromGreen + (toGreen - fromGreen) * ratio,
      blue: fromBlue + (toBlue - fromBlue) * ratio,
      alpha: 1
    )
  }

  private func font(from fromFont: UIFont, toFont: UIFont, ratio: CGFloat) -> UIFont {
    return UIFont(
      name: fromFont.fontName,
      size: fromFont.pointSize + (toFont.pointSize - fromFont.pointSize) * ratio
    )!
  }

}

