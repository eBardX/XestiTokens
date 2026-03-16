// © 2025–2026 John Gary Pusey (see LICENSE.md)

import Testing
@testable import XestiTokens
import XestiTools

private typealias Kind  = Token.Kind
private typealias Rule  = Tokenizer.Rule
private typealias Token = Tokenizer.Token

extension Kind {
    fileprivate static let number = Self("number")
    fileprivate static let text   = Self("text")
}

nonisolated(unsafe) private let rules: [Rule] = [Rule(/[0-9]+/, .number),
                                                 Rule(/[A-Za-z]+/, .text),
                                                 Rule(regex: /\s+/,
                                                      disposition: .skip(nil))]

nonisolated(unsafe) private let tokenizer = Tokenizer(rules: rules,
                                                      tracing: .silent)

struct WordNumberSyntaxTests {
}

// MARK: -

extension WordNumberSyntaxTests {
    @Test
    func numbers() throws {
        let tokens = try tokenizer.tokenize(input: "  233 2    1  23123    3333333     324    33    2")

        assertEqualTokens(actual: tokens,
                          expected: [_makeToken(.number, "233"),
                                     _makeToken(.number, "2"),
                                     _makeToken(.number, "1"),
                                     _makeToken(.number, "23123"),
                                     _makeToken(.number, "3333333"),
                                     _makeToken(.number, "324"),
                                     _makeToken(.number, "33"),
                                     _makeToken(.number, "2")])
    }

    @Test
    func words() throws {
        let tokens = try tokenizer.tokenize(input: "  HELLO  h i abc  ABC   Hi   hello         boy        XD")

        assertEqualTokens(actual: tokens,
                          expected: [_makeToken(.text, "HELLO"),
                                     _makeToken(.text, "h"),
                                     _makeToken(.text, "i"),
                                     _makeToken(.text, "abc"),
                                     _makeToken(.text, "ABC"),
                                     _makeToken(.text, "Hi"),
                                     _makeToken(.text, "hello"),
                                     _makeToken(.text, "boy"),
                                     _makeToken(.text, "XD")])
    }

    @Test
    func wordsAndNumbers() throws {
        let tokens = try tokenizer.tokenize(input: "  233 2    1  23123abc  ABC   Hi3333333     324    33    2")

        assertEqualTokens(actual: tokens,
                          expected: [_makeToken(.number, "233"),
                                     _makeToken(.number, "2"),
                                     _makeToken(.number, "1"),
                                     _makeToken(.number, "23123"),
                                     _makeToken(.text, "abc"),
                                     _makeToken(.text, "ABC"),
                                     _makeToken(.text, "Hi"),
                                     _makeToken(.number, "3333333"),
                                     _makeToken(.number, "324"),
                                     _makeToken(.number, "33"),
                                     _makeToken(.number, "2")])
    }
}

// MARK: - Private Functions

private func _makeToken(_ kind: Kind,
                        _ value: String) -> Token {
    Token(kind, Substring(value), TextLocation(1, 1))
}
