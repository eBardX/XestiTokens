// © 2025–2026 John Gary Pusey (see LICENSE.md)

private import XestiTools

/// A matcher that processes the provided sequence of tokens.
public struct TokenMatcher<S: Sequence> where S.Element == Tokenizer.Token {

    // MARK: Public Nested Types

    /// A type representing the kind of token.
    public typealias Kind = Tokenizer.Token.Kind

    /// A type representing a token.
    public typealias Token = Tokenizer.Token

    // MARK: Public Initializers

    /// Creates a new, _single-use_ token matcher.
    ///
    /// - Parameter tokens:    The sequence of tokens to process.
    public init(_ tokens: S) {
        self.baseReader = SequenceReader(tokens)
    }

    // MARK: Private Instance Properties

    private var baseReader: SequenceReader<S>
}

// MARK: -

extension TokenMatcher {

    // MARK: Public Instance Properties

    /// A Boolean value indicating whether there are more tokens available in
    /// the sequence.
    public var hasMore: Bool {
        baseReader.hasMore
    }

    // MARK: Public Instance Methods

    /// Unconditionally throws an error.
    ///
    /// If there are no more tokens available in the sequence, an appropriate
    /// error is thrown. Otherwise, an error complaining that the next token is
    /// unexpected is thrown.
    public mutating func failOnNext() throws {
        guard let token = baseReader.read()
        else { throw Error.noMoreTokens }

        throw Error.unexpectedToken(token)
    }

    /// Returns a Boolean value indicating whether there is a next, matching
    /// token in the sequence.
    ///
    /// - Parameter kind:   The token kind to match.
    ///
    /// - Returns:  `true` if there is a next, matching token in the sequence;
    ///             otherwise, `false`.
    public func nextMatches(_ kind: Kind) -> Bool {
        nextMatches([kind])
    }

    /// Returns a Boolean value indicating whether there is a next, matching
    /// token in the sequence.
    ///
    /// - Parameter kinds:  The set of token kinds to match.
    ///
    /// - Returns:  `true` if there is a next, matching token in the sequence;
    ///             otherwise, `false`.
    public func nextMatches(_ kinds: [Kind]) -> Bool {
        guard let token = baseReader.peek(),
              kinds.contains(token.kind)
        else { return false }

        return true
    }

    /// Removes the next, matching token from the sequence and returns it.
    ///
    /// - Parameter kind:   The token kind to match.
    ///
    /// - Returns:  The next, matching token from the sequence, if it exists;
    ///             otherwise, `nil`.
    @discardableResult
    public mutating func readIfMatches(_ kind: Kind) -> Token? {
        readIfMatches([kind])
    }

    /// Removes the next, matching token from the sequence and returns it.
    ///
    /// - Parameter kinds:  The set of token kinds to match.
    ///
    /// - Returns:  The next, matching token from the sequence, if it exists;
    ///             otherwise, `nil`.
    @discardableResult
    public mutating func readIfMatches(_ kinds: [Kind]) -> Token? {
        guard let token = baseReader.peek(),
              kinds.contains(token.kind)
        else { return nil }

        baseReader.skip()

        return token
    }

    /// Removes the next, matching token from the sequence and returns it.
    ///
    /// - Parameter kind:   The token kind to match.
    ///
    /// - Returns:  The next, matching token from the sequence.
    @discardableResult
    public mutating func readMustMatch(_ kind: Kind) throws -> Token {
        try readMustMatch([kind])
    }

    /// Removes the next, matching token from the sequence and returns it.
    ///
    /// - Parameter kinds:  The set of token kinds to match.
    ///
    /// - Returns:  The next, matching token from the sequence.
    @discardableResult
    public mutating func readMustMatch(_ kinds: [Kind]) throws -> Token {
        guard let token = baseReader.read()
        else { throw Error.noMoreTokens }

        guard kinds.contains(token.kind)
        else { throw Error.unexpectedToken(token) }

        return token
    }
}
