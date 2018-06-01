//
//  LightsManager.swift
//  Home
//
//  Created by Sebastien Villar on 5/28/18.
//  Copyright © 2018 -. All rights reserved.
//

import Foundation

class LightsManager {

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

    LightsApi.patch(id: lightID, model: lightModel) { response in
      DispatchQueue.main.async {
        switch response {
        case .success(let httpResponse, let model):
          dataSource.updateIfNeeded(with: httpResponse, model: model)
          break
        case .failure(let statusCode, let message):
          AlertController.shared.show(request: "Set status: \(lightID)", statusCode: statusCode, message: message)
          break
        }
      }
    }
  }
}
