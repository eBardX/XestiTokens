// © 2025–2026 John Gary Pusey (see LICENSE.md)

import XestiTools

extension TokenMatcher {
    /// An error that occurs while processing the sequence of tokens.
    public enum Error {
        /// There are no more tokens available in the sequence.
        case noMoreTokens

        /// An unexpected token was encountered in the sequence.
        ///
        /// As an associated value, this case contains the unexpected token.
        case unexpectedToken(Token)
    }
}

// MARK: - EnhancedError

extension TokenMatcher.Error: EnhancedError {
    public var message: String {
        switch self {
        case .noMoreTokens:
            "No more tokens"

        case let .unexpectedToken(token):
            "Unexpected token: \(token)"
        }
    }
}

// MARK: - Sendable

extension TokenMatcher.Error: Sendable {
}
