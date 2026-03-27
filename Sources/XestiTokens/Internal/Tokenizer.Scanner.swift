// © 2025–2026 John Gary Pusey (see LICENSE.md)

internal import XestiTools

extension Tokenizer {

    // MARK: Internal Nested Types

    internal struct Scanner {

        // MARK: Internal Initializers

        internal init(rules: [Rule],
                      input: String,
                      userInfo: [UserInfoKey: any Sendable],
                      tracing: Verbosity) {
            self.currentCondition = .initial
            self.currentIndex = input.startIndex
            self.input = input
            self.rules = rules
            self.tracing = tracing
            self.userInfo = userInfo
        }

        // MARK: Private Instance Properties

        private let input: String
        private let rules: [Rule]
        private let tracing: Verbosity

        private var currentCondition: StartCondition
        private var currentIndex: String.Index
        private var userInfo: [UserInfoKey: any Sendable]
    }
}

// MARK: -

extension Tokenizer.Scanner {

    // MARK: Internal Instance Methods

    internal mutating func scanTokens() throws -> [Tokenizer.Token] {
        var tokens: [Tokenizer.Token] = []

        if tracing >= .quiet {
            print("----------")
        }

        while currentIndex < input.endIndex {
            let token = try _scanBestToken()

            if tracing >= .verbose {
                print("----------")
            }

            if let token {
                tokens.append(token)
            }
        }

        if tracing >= .quiet {
            print("### Resulting tokens:")

            for token in tokens {
                print("=== \(token.debugDescription)")
            }

            print("----------")
        }

        return tokens
    }

    // MARK: Private Instance Methods

    private mutating func _scanBestToken() throws -> Tokenizer.Token? {
        let text = input[currentIndex...]
        let location = text.location

        if tracing >= .verbose {
            print("*** Attempting to match text beginning: \(text.escapedPrefix(location: location)), currentCondition: \(currentCondition)")
        }

        var matchRule: Tokenizer.Rule?
        var matchIndex = currentIndex
        var matchValue: Substring?

        for rule in rules where rule.isActive(for: currentCondition) {
            if tracing >= .veryVerbose {
                print("--- Trying rule \(rule)")
            }

            guard let match = try? rule.regex.prefixMatch(in: text),
                  match.range.lowerBound == currentIndex,
                  match.range.upperBound > matchIndex
            else { continue }

            if tracing >= .veryVerbose {
                print("--- Updating best match")
            }

            matchIndex = match.range.upperBound
            matchRule = rule
            matchValue = match.output
        }

        guard let rule = matchRule,
              let value = matchValue,
              matchIndex > currentIndex
        else { throw Tokenizer.Error.unrecognizedToken(text, location) }

        currentIndex = matchIndex

        let outCondition: Tokenizer.StartCondition?
        let token: Tokenizer.Token?

        if let disposition = try rule.action(value,
                                             currentCondition,
                                             &userInfo) ?? rule.disposition {
            switch disposition {
            case let .save(kind, cond):
                outCondition = cond ?? currentCondition
                token = Tokenizer.Token(kind, value, location)

            case let .skip(cond):
                outCondition = cond ?? currentCondition
                token = nil
            }
        } else {
            outCondition = currentCondition
            token = nil
        }

        if let outCondition,
           currentCondition != outCondition {
            currentCondition = outCondition
        }

        if tracing >= .verbose {
            if let token {
                print("+++ Saving token: \(token.debugDescription)")
            } else {
                let prefix = value.escapedPrefix(maxLength: value.count,
                                                 location: location)

                print("+++ Skipping token: \(prefix)")
            }
        }

        return token
    }
}
