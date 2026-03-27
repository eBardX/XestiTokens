// © 2025–2026 John Gary Pusey (see LICENSE.md)

public import XestiTools

extension Tokenizer {

    // MARK: Public Nested Types

    /// A type representing a key in the tokenizer’s dictionary of contextual
    /// information.
    public struct UserInfoKey: StringRepresentable {

        // MARK: Public Initializers

        /// Creates a new user information key with the provided string value.
        ///
        /// If the provided string value is empty, this initializer returns
        /// `nil`.
        ///
        /// - Parameter stringValue:    The string value to use for the new user
        ///                             information key.
        public init?(stringValue: String) {
            guard Self.isValid(stringValue)
            else { return nil }

            self.stringValue = stringValue
        }

        // MARK: Public Instance Properties

        /// The string value representing this user information key.
        ///
        /// A new user information key instance initialized with `stringValue`
        /// will be equivalent to this instance.
        public let stringValue: String
    }
}
