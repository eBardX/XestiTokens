// © 2025–2026 John Gary Pusey (see LICENSE.md)

import XestiTools

extension Tokenizer {

    // MARK: Public Nested Types

    /// An error that occurs while tokenizing the input string.
    public enum Error {
        /// An unrecognized token has been encountered in the input string.
        ///
        /// As associated values, this case contains the portion of the input
        /// string beginning with the unrecognized token, as well as its
        /// location in the complete input string.
        case unrecognizedToken(Substring, TextLocation)
    }
}

// MARK: - EnhancedError

extension Tokenizer.Error: EnhancedError {
    public var message: String {
        switch self {
        case let .unrecognizedToken(value, location):
            "Unrecognized token beginning: \(value.escapedPrefix(location: location))"
        }
    }
}

// MARK: - Sendable

extension Tokenizer.Error: Sendable {
}
