
//
//  BiometricTest.swift
//  LeagueInfo
//
//  Created by issd on 21/10/2018.
//  Copyright © 2018 issd. All rights reserved.
//

import Foundation
import LocalAuthentication

var biometricType: LABiometryType {
    let authContext = LAContext()
    if authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
    {
      if authContext.biometryType == LABiometryType.touchID
      {
        return authContext.biometryType
      }
        else if authContext.biometryType == LABiometryType.faceID
      {
        return authContext.biometryType
      }
        else if authContext.biometryType == LABiometryType.none
      {
        return authContext.biometryType
        }
    
    }
    return authContext.biometryType
}
