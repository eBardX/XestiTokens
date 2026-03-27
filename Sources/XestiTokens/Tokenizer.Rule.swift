// © 2025–2026 John Gary Pusey (see LICENSE.md)

private import XestiTools

extension Tokenizer {

    // MARK: Public Nested Types

    /// A tokenizer rule.
    public struct Rule {

        // MARK: Public Initializers

        /// Creates a new rule.
        ///
        /// This initializer is a shorthand for the following:
        ///
        /// ```swift
        /// init(regex: regex,
        ///      disposition: .save(outKind, nil))
        /// ```
        ///
        /// - Parameter regex:      The regular expression to match against.
        /// - Parameter outKind:    The kind of token the matching string value
        ///                         should be saved as.
        public init(_ regex: Regex<Substring>,
                    _ outKind: Token.Kind) {
            self.init(regex: regex,
                      disposition: .save(outKind, nil))
        }

        /// Creates a new rule matching the given regular expression and start
        /// conditions.
        ///
        /// - Parameter regex:              The regular expression to match
        ///                                 against.
        /// - Parameter startConditions:    A set of start conditions under
        ///                                 which this rule will be active.
        ///                                 Defaults to a set containing
        ///                                 `.initial` only.
        /// - Parameter disposition:        An optional disposition to realize
        ///                                 if this rule matches. Defaults to
        ///                                 `nil`.
        /// - Parameter action:             An optional action to perform if
        ///                                 this rule matches. If `nil`, a
        ///                                 default action that simply returns
        ///                                 `nil` is used. Defaults to `nil`.
        public init(regex: Regex<Substring>,
                    startConditions: Set<StartCondition> = [.initial],
                    disposition: Disposition? = nil,
                    action: Action? = nil) {
            self.action = action ?? { _, _, _ in nil }
            self.startConditions = startConditions
            self.disposition = disposition
            self.id = ID()
            self.regex = regex
        }

        // MARK: Public Instance Properties

        /// The action to perform if this rule matches.
        public let action: Action

        /// The optional disposition to realize if this rule matches.
        public let disposition: Disposition?

        /// The stable identity of this rule.
        public let id: ID

        /// The regular expression to match against.
        public let regex: Regex<Substring>

        /// The set of start conditions under which this rule will be active.
        public let startConditions: Set<StartCondition>

        // MARK: Internal Instance Methods

        internal func isActive(for startCondition: StartCondition) -> Bool {
            if startCondition.isInclusive {
                startConditions.contains(startCondition) || startConditions.contains(.initial)
            } else {
                startConditions.contains(startCondition)
            }
        }
    }
}

// MARK: - CustomStringConvertible

extension Tokenizer.Rule: CustomStringConvertible {
    public var description: String {
        "‹\(String(describing: id))›(\(_formatRegex(regex)), \(_formatConditions(startConditions)), \(_formatDisposition(disposition)))"
    }
}

// MARK: - Equatable

extension Tokenizer.Rule: Equatable {
    public static func == (lhs: Self,
                           rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Hashable

extension Tokenizer.Rule: Hashable {
    public func hash(into hasher: inout Hasher) {
        id.hash(into: &hasher)
    }
}

// MARK: - Identifiable

extension Tokenizer.Rule: Identifiable {
}

// MARK: - Private Functions

private func _formatConditions(_ conditions: Set<Tokenizer.StartCondition>) -> String {
    let items = conditions.map { String(describing: $0) }.sorted()

    return "[" + items.joined(separator: ",") + "]"
}

private func _formatDisposition(_ disposition: Tokenizer.Disposition?) -> String {
    guard let disposition
    else { return "dynamic" }

    return String(describing: disposition)
}

private func _formatRegex(_ regex: Regex<Substring>) -> String {
    guard let pattern = regex.safeLiteralPattern
    else { return "unknown" }

    return "/" + liteEscape(pattern) + "/"
}
