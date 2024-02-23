//
//  Date+Extensions.swift
//  ImageFeed
//
//  Created by Владимир Горбачев on 23.02.2024.
//

import Foundation

private var dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .long
    formatter.timeStyle = .none
    return formatter
}()

extension Date {
    var dateString: String { dateFormatter.string(from: self) }
}

