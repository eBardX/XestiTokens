// © 2025–2026 John Gary Pusey (see LICENSE.md)

import Testing
@testable import XestiTokens
import XestiTools

private typealias Kind  = Token.Kind
private typealias Rule  = Tokenizer.Rule
private typealias Token = Tokenizer.Token

extension Kind {
    fileprivate static let float            = Self("float")
    fileprivate static let integer          = Self("integer")
    fileprivate static let leftParenthesis  = Self("leftParenthesis")
    fileprivate static let op               = Self("op")
    fileprivate static let rightParenthesis = Self("rightParenthesis")
}

nonisolated(unsafe) private let rules: [Rule] = [Rule(/[0-9]+\.[0-9]+/, .float),
                                                 Rule(/[0-9]+/, .integer),
                                                 Rule(/\(/, .leftParenthesis),
                                                 Rule(/[\-\*\/\+]/, .op),
                                                 Rule(/\)/, .rightParenthesis),
                                                 Rule(regex: /\s+/,
                                                      disposition: .skip(nil))]

nonisolated(unsafe) private let tokenizer = Tokenizer(rules: rules,
                                                      tracing: .silent)

struct CalculatorSyntaxTests {
}

// MARK: -

extension CalculatorSyntaxTests {
    @Test
    func complexExpression() throws {
        let tokens = try tokenizer.tokenize(input: "( 1332.4322  +       1   ) *2 / 44.44 + ((2.3- 2) * 4  )   / 0.3       ")

        assertEqualTokens(actual: tokens,
                          expected: [_makeToken(.leftParenthesis, "("),
                                     _makeToken(.float, "1332.4322"),
                                     _makeToken(.op, "+"),
                                     _makeToken(.integer, "1"),
                                     _makeToken(.rightParenthesis, ")"),
                                     _makeToken(.op, "*"),
                                     _makeToken(.integer, "2"),
                                     _makeToken(.op, "/"),
                                     _makeToken(.float, "44.44"),
                                     _makeToken(.op, "+"),
                                     _makeToken(.leftParenthesis, "("),
                                     _makeToken(.leftParenthesis, "("),
                                     _makeToken(.float, "2.3"),
                                     _makeToken(.op, "-"),
                                     _makeToken(.integer, "2"),
                                     _makeToken(.rightParenthesis, ")"),
                                     _makeToken(.op, "*"),
                                     _makeToken(.integer, "4"),
                                     _makeToken(.rightParenthesis, ")"),
                                     _makeToken(.op, "/"),
                                     _makeToken(.float, "0.3")])
    }

    @Test
    func floatIntSum() throws {
        let tokens = try tokenizer.tokenize(input: "   1332.4322  +       1   ")

        assertEqualTokens(actual: tokens,
                          expected: [_makeToken(.float, "1332.4322"),
                                     _makeToken(.op, "+"),
                                     _makeToken(.integer, "1")])
    }

    @Test
    func floatSum() throws {
        let tokens = try tokenizer.tokenize(input: "1.2   +      1.004")

        assertEqualTokens(actual: tokens,
                          expected: [_makeToken(.float, "1.2"),
                                     _makeToken(.op, "+"),
                                     _makeToken(.float, "1.004")])
    }

    @Test
    func intSum() throws {
        let tokens = try tokenizer.tokenize(input: "1 + 1")

        assertEqualTokens(actual: tokens,
                          expected: [_makeToken(.integer, "1"),
                                     _makeToken(.op, "+"),
                                     _makeToken(.integer, "1")])
    }
}

// MARK: - Private Functions

private func _makeToken(_ kind: Kind,
                        _ value: String) -> Token {
    Token(kind, Substring(value), TextLocation(1, 1))
}
