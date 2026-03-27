// © 2025–2026 John Gary Pusey (see LICENSE.md)

public import XestiTools

extension Tokenizer {

    // MARK: Public Nested Types

    /// A type representing a tokenizer token, including its kind and string
    /// value, as well as its location in the input string.
    public struct Token {

        // MARK: Public Instance Properties

        /// The kind of this token.
        public let kind: Kind

        /// The location of this token in the input string.
        public let location: TextLocation

        /// The string value of this token.
        public let value: Substring

        // MARK: Internal Initializers

        internal init(_ kind: Kind,
                      _ value: Substring,
                      _ location: TextLocation) {
            self.kind = kind
            self.location = location
            self.value = value
        }
    }
}

// MARK: - CustomDebugStringConvertible

extension Tokenizer.Token: CustomDebugStringConvertible {
    public var debugDescription: String {
        "\(kind)(«\(liteEscape(value))»), line: \(location.line), column: \(location.column)"
    }
}

// MARK: - CustomStringConvertible

extension Tokenizer.Token: CustomStringConvertible {
    public var description: String {
        "\(String(describing: kind))(«\(liteEscape(value))»)"
    }
}

// MARK: - Sendable

extension Tokenizer.Token: Sendable {
}
