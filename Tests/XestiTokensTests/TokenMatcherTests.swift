// © 2025–2026 John Gary Pusey (see LICENSE.md)

import Testing
@testable import XestiTokens
import XestiTools

private typealias Kind    = Tokenizer.Token.Kind
private typealias Matcher = TokenMatcher<[Tokenizer.Token]>
private typealias Token   = Tokenizer.Token

struct TokenMatcherTests {
}

// MARK: -

extension TokenMatcherTests {
    @Test
    func test_failOnNextThrowsNoMoreTokens() {
        var matcher = Matcher([])

        #expect(throws: Matcher.Error.self) {
            try matcher.failOnNext()
        }
    }

    @Test
    func test_failOnNextThrowsUnexpectedToken() {
        var matcher = Matcher([_makeToken(.number, "42")])

        #expect(throws: Matcher.Error.self) {
            try matcher.failOnNext()
        }
    }

    @Test
    func test_hasMoreAfterExhausted() {
        var matcher = Matcher([_makeToken(.number, "1")])

        _ = matcher.readIfMatches(.number)

        #expect(!matcher.hasMore)
    }

    @Test
    func test_hasMoreWhenEmpty() {
        let matcher = Matcher([])

        #expect(!matcher.hasMore)
    }

    @Test
    func test_hasMoreWithTokens() {
        let matcher = Matcher([_makeToken(.number, "1")])

        #expect(matcher.hasMore)
    }

    @Test
    func test_nextMatchesReturnsFalseWhenEmpty() {
        let matcher = Matcher([])

        #expect(!matcher.nextMatches(.number))
    }

    @Test
    func test_nextMatchesReturnsFalseWhenNoMatch() {
        let matcher = Matcher([_makeToken(.word, "hello")])

        #expect(!matcher.nextMatches(.number))
    }

    @Test
    func test_nextMatchesReturnsTrueWhenMatched() {
        let matcher = Matcher([_makeToken(.number, "42")])

        #expect(matcher.nextMatches(.number))
    }

    @Test
    func test_nextMatchesWithMultipleKinds() {
        let matcher = Matcher([_makeToken(.word, "hello")])

        #expect(matcher.nextMatches([.number, .word]))
        #expect(!matcher.nextMatches([.number]))
    }

    @Test
    func test_readIfMatchesReturnsNilWhenEmpty() {
        var matcher = Matcher([])

        let token = matcher.readIfMatches(.number)

        #expect(token == nil)
    }

    @Test
    func test_readIfMatchesReturnsNilWhenNoMatch() {
        var matcher = Matcher([_makeToken(.word, "hello")])

        let token = matcher.readIfMatches(.number)

        #expect(token == nil)
        #expect(matcher.hasMore)
    }

    @Test
    func test_readIfMatchesReturnsTokenWhenMatched() {
        var matcher = Matcher([_makeToken(.number, "42")])

        let token = matcher.readIfMatches(.number)

        #expect(token != nil)
        #expect(token?.kind == .number)
        #expect(token?.value == "42")
        #expect(!matcher.hasMore)
    }

    @Test
    func test_readIfMatchesWithMultipleKinds() {
        var matcher = Matcher([_makeToken(.word, "hello")])

        let token = matcher.readIfMatches([.number, .word])

        #expect(token != nil)
        #expect(token?.kind == .word)
    }

    @Test
    func test_readMustMatchReturnsToken() throws {
        var matcher = Matcher([_makeToken(.number, "42")])

        let token = try matcher.readMustMatch(.number)

        #expect(token.kind == .number)
        #expect(token.value == "42")
    }

    @Test
    func test_readMustMatchThrowsNoMoreTokens() {
        var matcher = Matcher([])

        #expect(throws: Matcher.Error.self) {
            try matcher.readMustMatch(.number)
        }
    }

    @Test
    func test_readMustMatchThrowsUnexpectedToken() {
        var matcher = Matcher([_makeToken(.word, "hello")])

        #expect(throws: Matcher.Error.self) {
            try matcher.readMustMatch(.number)
        }
    }

    @Test
    func test_readMustMatchWithMultipleKinds() throws {
        var matcher = Matcher([_makeToken(.word, "hello"),
                               _makeToken(.number, "42")])

        let token = try matcher.readMustMatch([.number, .word])

        #expect(token.kind == .word)
        #expect(token.value == "hello")
    }
}

// MARK: - Private

extension Kind {
    fileprivate static let number = Self("number")
    fileprivate static let word   = Self("word")
}

private func _makeToken(_ kind: Kind,
                        _ value: String) -> Token {
    Token(kind, Substring(value), TextLocation(1, 1))
}
