//
//  Structures.swift
//  Manager
//
//  Created by Daria Pr on 01.11.2020.
//

import Foundation

struct Profile {
    let profileName: String
    let age: String
    let email: String
}

struct Calendar {
    let date: String
    let descrDate: String
}

struct Expenses {
    var food: Int
    var transport: Int
    var housing: Int
    var clothing: Int
    var cafe: Int
    var health: Int
    var entertainment: Int
    var presents: Int
    var other: Int
}

struct Tasks {
    let task: String
    let complete: Bool
}

struct Focus {
    var amount: Int
    let incomplete: Int
    var completeSmall: Int
    var completeMedium: Int
    var completeLarge: Int
}
