// © 2025–2026 John Gary Pusey (see LICENSE.md)

import XestiTools

/// A rules-based lexical tokenizer.
public struct Tokenizer {

    // MARK: Public Initializers

    /// Creates a new, reusable tokenizer with the provided rules, user
    /// information, and tracing verbosity.
    ///
    /// - Parameter rules:      An array of ``Rule`` instances describing the
    ///                         tokens that will be recognized by the tokenizer.
    /// - Parameter userInfo:   A dictionary of contextual information. Empty by
    ///                         default.
    /// - Parameter tracing:    The tracing verbosity to use when tokenizing.
    ///                         The default tracing verbosity is `.silent`.
    public init(rules: [Rule],
                userInfo: [UserInfoKey: any Sendable] = [:],
                tracing: Verbosity = .silent) {
        self.rules = rules
        self.tracing = tracing
        self.userInfo = userInfo
    }

    // MARK: Public Instance Properties

    /// The array of ``Rule`` instances describing the tokens that are
    /// recognized by this tokenizer.
    public let rules: [Rule]

    /// The tracing verbosity used when tokenizing.
    public let tracing: Verbosity

    /// The dictionary used to customize the tokenization process by providing
    /// contextual information.
    public let userInfo: [UserInfoKey: any Sendable]

    // MARK: Public Instance Methods

    /// Converts the provided input string into an array of ``Token`` instances.
    ///
    /// - Parameter input:  The input string to tokenize.
    ///
    /// - Returns:  The array of recognized tokens.
    public func tokenize(input: String) throws -> [Token] {
        var scanner = Scanner(rules: rules,
                              input: input,
                              userInfo: userInfo,
                              tracing: tracing)

        return try scanner.scanTokens()
    }
}
