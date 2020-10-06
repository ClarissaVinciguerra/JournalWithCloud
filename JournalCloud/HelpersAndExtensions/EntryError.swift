//
//  EntryError.swift
//  JournalCloud
//
//  Created by Clarissa Vinciguerra on 10/5/20.
//

import Foundation

enum EntryError: LocalizedError {
    case ckError(Error)
    case couldNotUnwrap
}
