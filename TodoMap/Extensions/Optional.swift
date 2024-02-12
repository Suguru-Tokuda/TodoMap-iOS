//
//  Optional.swift
//  TodoMap
//
//  Created by Suguru Tokuda on 2/9/24.
//

import Foundation
import Combine

extension Optional where Wrapped: Combine.Publisher {
    func orEmpty() -> AnyPublisher<Wrapped.Output, Wrapped.Failure> {
        self?.eraseToAnyPublisher() ?? Empty().eraseToAnyPublisher()
    }
}
