// © 2025–2026 John Gary Pusey (see LICENSE.md)

import Testing
@testable import XestiTokens
import XestiTools

private typealias Kind         = Tokenizer.Token.Kind
private typealias Matcher      = TokenMatcher<[Tokenizer.Token]>
private typealias MatcherError = Matcher.Error
private typealias Token        = Tokenizer.Token

struct TokenMatcherErrorTests {
}

// MARK: -

extension TokenMatcherErrorTests {
    @Test
    func test_messageNoMoreTokens() {
        let error: MatcherError = .noMoreTokens

        #expect(error.message == "No more tokens")
    }

    @Test
    func test_messageUnexpectedToken() {
        let token = Token(Kind("number"), Substring("42"), TextLocation(1, 1))
        let error: MatcherError = .unexpectedToken(token)

        #expect(error.message == "Unexpected token: ‹number›(«42»)")
    }
}
