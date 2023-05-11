//
//  HttpError.swift
//  diablo3Before
//
//  Created by jinwoong Kim on 2023/04/04.
//

import Foundation

enum HttpError: LocalizedError {
  case invalidRequest
  case unexpectedBody
  
  var errorDescription: String? {
    switch self {
      case .invalidRequest:
        return NSLocalizedString("The request could not be made. Please check and try again.", comment: "Invalid Request")
        
      case .unexpectedBody:
        return NSLocalizedString("There was a problem with your input. Please check and try again.", comment: "Unexpected Body")
    }
  }
}
