//
//  VersionAPI.swift
//  AppTemplateiOS
//
//  Created by Junio Moquiuti on 10/09/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

public class VersionAPI: Codable {

   public var required: Bool
   public var versionNumber: Int
   public var buildNumber: Int?
   
   enum CodingKeys: String, CodingKey {
      case versionNumber = "version_number"
      case buildNumber = "build_number"
      case required
   }
}
