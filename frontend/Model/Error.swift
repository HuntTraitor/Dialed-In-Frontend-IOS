//
//  Error.swift
//  frontend
//
//  Created by Hunter Tratar on 1/2/25.
//

enum CustomError: Error {
    case verifyUserError(message: String)
    case methodError(message: String)
}
