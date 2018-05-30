//
//  SettingsView.swift
//  Home
//
//  Created by Sebastien Villar on 5/29/18.
//  Copyright © 2018 -. All rights reserved.
//

import Foundation
import UIKit

class SettingsView: UIView, UITableViewDataSource, UITableViewDelegate {

  private struct Constants {
    static let cancelBottomMargin: CGFloat = 26
  }

  // MARK: - Public

  struct Data {
    enum Section {
      case thermostatMode
    }

    enum Row {
      case warm(checked: Bool)
      case cool(checked: Bool)
    }

    let sectionToRows: [Section: [Row]]
    let sections: [Section]
  }

  private(set) var data: Data
  var onCancel: (() -> Void)?
  var onNewMode: ((Data.Row) -> Void)?

  init(data: Data) {
    self.data = data

    super.init(frame: .zero)

    backgroundColor = .backgroundGray

    cancelButton.addTarget(self, action: #selector(handleCancelTap), for: .touchUpInside)
    addSubview(cancelButton)

    tableView.backgroundColor = .backgroundGray
    tableView.separatorColor = .backgroundGray
    tableView.dataSource = self
    tableView.delegate = self
    tableView.register(SettingsModeCell.self, forCellReuseIdentifier: SettingsModeCell.identifier)
    tableView.register(SettingsHeaderView.self, forHeaderFooterViewReuseIdentifier: SettingsHeaderView.identifier)
    addSubview(tableView)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func setup(with data: Data) {
    self.data = data
    tableView.reloadData()
  }

  // MARK: - Super overrides

  override func layoutSubviews() {
    super.layoutSubviews()

    cancelButton.sizeToFit()
    cancelButton.frame = CGRect(
      x: layoutMargins.left,
      y: layoutMargins.left,
      width: cancelButton.width,
      height: cancelButton.height
    )

    tableView.frame = CGRect(
      x: 0,
      y: cancelButton.bottom + Constants.cancelBottomMargin,
      width: width,
      height: height - (cancelButton.bottom + Constants.cancelBottomMargin))
  }

  // MARK: - Private

  private let tableView = UITableView(frame: .zero, style: .grouped)
  private let cancelButton = CancelButton()

  // MARK: Handlers

  @objc private func handleCancelTap() {
    onCancel?()
  }

  // MARK: Datasource

  func numberOfSections(in tableView: UITableView) -> Int {
    return data.sections.count
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let sectionType = data.sections[section]
    return data.sectionToRows[sectionType]?.count ?? 0
  }

  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: SettingsHeaderView.identifier) as! SettingsHeaderView

    let title: String = {
      switch data.sections[section] {
      case .thermostatMode:
        return "Thermostat mode"
      }
    }()

    headerView.setup(with: title)
    return headerView
  }

  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return SettingsHeaderView.height
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let section = data.sections[indexPath.section]
    guard let row = data.sectionToRows[section]?[indexPath.row] else {
      return UITableViewCell()
    }

    switch row {
    case .warm(let checked):
      let model = SettingsModeCellModel(title: "Warm", checked: checked)
      let cell = tableView.dequeueReusableCell(withIdentifier: SettingsModeCell.identifier, for: indexPath) as! SettingsModeCell
      cell.setup(with: model)
      return cell
    case .cool(let checked):
      let model = SettingsModeCellModel(title: "Cool", checked: checked)
      let cell = tableView.dequeueReusableCell(withIdentifier: SettingsModeCell.identifier, for: indexPath) as! SettingsModeCell
      cell.setup(with: model)
      return cell
    }
  }

  // MARK: Delegate

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let section = data.sections[indexPath.section]
    guard let row = data.sectionToRows[section]?[indexPath.row] else {
      return
    }

    switch row {
    case .warm:
      onNewMode?(.warm(checked: true))
    case .cool:
      onNewMode?(.cool(checked: true))
    }
  }
}
