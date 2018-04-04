//
//  Json.swift
//  Home
//
//  Created by Sebastien Villar on 04/04/2018.
//  Copyright © 2018 -. All rights reserved.
//

import Foundation

class Json<T> {

  // MARK: - Public

  let data: Data
  let object: T

  init?(object: T) {
    self.object = object

    do {
      self.data = try JSONSerialization.data(withJSONObject: object, options: [])
    }
    catch {
      // Error
      Logger.error("Cannot serialize object to Json data: \(object)")
      return nil
    }
  }

  init?(data: Data) {
    self.data = data

    do {
      guard let object = try JSONSerialization.jsonObject(with: data, options: []) as? T else {
        Logger.error("Cannot deserialize data to Json object: \(data)")
        return nil
      }

      self.object = object
    }
    catch {
      // Error
      Logger.error("Cannot deserialize data to Json dictionary: \(data)")
      return nil
    }
  }

  func object<T: Decodable>(at path: String) -> T? {
    guard var currentObject = object as? [String: Any] else {
      Logger.info("Key path not usable on json: \(object)")
      return nil
    }

    var keyQueue = path.split(separator: ".")

    while !keyQueue.isEmpty {
      let key = String(keyQueue.removeFirst())

      guard let newObject = currentObject[key] as? [String: Any] else {
        Logger.info("Key path not found in json - path: \(path), json: \(object)")
        return nil
      }

      if keyQueue.isEmpty {
        // Find the last element and cast to T
        guard let json = Json<[String: Any]>(object: newObject) else {
          Logger.info("Object is of incorrect type: \(object)")
          return nil
        }

        do {
          return try JSONDecoder().decode(T.self, from: json.data)
        }
        catch let e {
          Logger.error("Cannot parse Json into object of type: \(T.self), object: \(object), error: \(e)")
          return nil
        }
      }

      currentObject = newObject
    }

    return nil

  }

  // MARK: - Private
}
