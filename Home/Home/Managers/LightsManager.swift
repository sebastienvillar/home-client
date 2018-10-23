//
//  LightsManager.swift
//  Home
//
//  Created by Sebastien Villar on 5/28/18.
//  Copyright © 2018 -. All rights reserved.
//

import Foundation

class LightsManager {

  // MARK: - Public

  static func setStatus(_ status: LightModel.Status, lightID: String, dataSource: DataSource) {
    guard var lightModels = dataSource.lightModels else {
      return
    }

    guard let lightModelIndex = lightModels.index(where: { $0.id == lightID }) else {
      return
    }

    var lightModel = lightModels[lightModelIndex]
    lightModel.status = status
    lightModel.keysToEncode = [LightModel.CodingKeys.status]
    lightModels[lightModelIndex] = lightModel

    guard lightModels != dataSource.lightModels else {
      return
    }

    dataSource.lightModels = lightModels
    patch(id: lightID, model: lightModel, dataSource: dataSource)
  }

  static func setBrightness(_ brightness: Int, lightID: String, dataSource: DataSource) {
    guard var lightModels = dataSource.lightModels else {
      return
    }

    guard let lightModelIndex = lightModels.index(where: { $0.id == lightID }) else {
      return
    }

    var lightModel = lightModels[lightModelIndex]
    lightModel.brightness = brightness
    lightModel.keysToEncode = [LightModel.CodingKeys.brightness]
    lightModels[lightModelIndex] = lightModel

    guard lightModels != dataSource.lightModels else {
      return
    }

    dataSource.lightModels = lightModels
    patch(id: lightID, model: lightModel, dataSource: dataSource)
  }

  // MARK: - Private

  private static func patch(id: String, model: LightModel, dataSource: DataSource) {
    LightsApi.patch(id: id, model: model) { response in
      DispatchQueue.main.async {
        switch response {
        case .success(let httpResponse, let model):
          dataSource.updateIfNeeded(with: httpResponse, model: model)
        case .failure(let statusCode, let message):
          AlertController.shared.show(request: "Patch model: \(model)", statusCode: statusCode, message: message)
        }
      }
    }
  }
}
