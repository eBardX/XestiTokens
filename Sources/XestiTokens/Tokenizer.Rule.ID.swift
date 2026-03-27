// © 2025–2026 John Gary Pusey (see LICENSE.md)

private import Foundation
private import XestiTools

extension Tokenizer.Rule {

    // MARK: Public Nested Types

    /// A type representing the stable identity of a tokenizer rule.
    public struct ID {                              // swiftlint:disable:this type_name

        // MARK: Public Initializers

        /// Creates a new unique rule ID.
        public init() {
            self.stringValue = "R$" + UUID().base62String
        }

        // MARK: Private Instance Properties

        private let stringValue: String
    }
}

// MARK: - CustomStringConvertible

extension Tokenizer.Rule.ID: CustomStringConvertible {
    public var description: String {
        stringValue
    }
}

// MARK: - Equatable

extension Tokenizer.Rule.ID: Equatable {
}

// MARK: - Hashable

extension Tokenizer.Rule.ID: Hashable {
}

// MARK: - Sendable

extension Tokenizer.Rule.ID: Sendable {
}
