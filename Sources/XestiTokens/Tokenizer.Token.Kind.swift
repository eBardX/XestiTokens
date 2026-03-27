// © 2025–2026 John Gary Pusey (see LICENSE.md)

public import XestiTools

extension Tokenizer.Token {

    // MARK: Public Nested Types

    /// A type representing the kind of tokenizer token.
    public struct Kind: StringRepresentable {

        // MARK: Public Initializers

        /// Creates a new token kind with the provided string value.
        ///
        /// If the provided string value is empty, this initializer returns
        /// `nil`.
        ///
        /// - Parameter stringValue:    The string value to use for the new
        ///                             token kind.
        public init?(stringValue: String) {
            guard Self.isValid(stringValue)
            else { return nil }

            self.stringValue = stringValue
        }

        // MARK: Public Instance Properties

        /// The string value representing this token kind.

        /// A new token kind instance initialized with `stringValue` will be
        /// equivalent to this instance.
        public let stringValue: String
    }
}

// MARK: - CustomStringConvertible

extension Tokenizer.Token.Kind: CustomStringConvertible {
    public var description: String {
        "‹" + stringValue + "›"
    }
}
