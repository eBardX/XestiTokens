// © 2025–2026 John Gary Pusey (see LICENSE.md)

extension Tokenizer {

    // MARK: Public Nested Types

    /// A type representing the disposition of a successful match during
    /// tokenization.
    public enum Disposition {
        /// The matching string value should be saved as a token.
        ///
        /// As associated values, this case contains the kind of token in which
        /// to save the string value, as weill as an optional start condition to
        /// which to change. If the start condition is `nil`, the tokenizer’s
        /// current start condition remains unchanged.
        case save(Tokenizer.Token.Kind, Tokenizer.StartCondition?)

        /// The matching string value should be skipped.
        ///
        /// As an associated value, this case contains an optional start
        /// condition to which to change. If the start condition is `nil`, the
        /// tokenizer’s current start condition remains unchanged.
        case skip(Tokenizer.StartCondition?)
    }
}

// MARK: - CustomStringConvertible

extension Tokenizer.Disposition: CustomStringConvertible {
    public var description: String {
        switch self {
        case let .save(kind, startCondition):
            "save(\(String(describing: kind)), \(String(describing: startCondition)))"

        case let .skip(startCondition):
            "skip(\(String(describing: startCondition)))"
        }
    }
}

// MARK: - Sendable

extension Tokenizer.Disposition: Sendable {
}
