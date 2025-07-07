//
//  CustomOption.swift
//  DialedIn
//
//  Created by Hunter Tratar on 7/7/25.
//

protocol CustomOption: Hashable, Identifiable, Codable {
    var displayName: String { get }
    static var predefinedOptions: [Self] { get }
    static func makeCustom(_ value: String) -> Self
}

protocol FixedOption: Codable, Identifiable, Equatable, Hashable {
    var displayName: String { get }
    static var predefinedOptions: [Self] { get }
}
