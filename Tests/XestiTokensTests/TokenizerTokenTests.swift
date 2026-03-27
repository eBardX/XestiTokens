// © 2025–2026 John Gary Pusey (see LICENSE.md)

import Testing
@testable import XestiTokens
import XestiTools

private typealias Kind  = Tokenizer.Token.Kind
private typealias Token = Tokenizer.Token

struct TokenizerTokenTests {
}

// MARK: -

extension TokenizerTokenTests {
    @Test
    func test_debugDescription() {
        let token = Token(Kind("number"), Substring("42"), TextLocation(3, 7))

        #expect(token.debugDescription == "‹number›(«42»), line: 3, column: 7")
    }

    @Test
    func test_description() {
        let token = Token(Kind("word"), Substring("hello"), TextLocation(1, 1))

        #expect(token.description == "‹word›(«hello»)")
    }

    @Test
    func test_kind() {
        let kind = Kind("number")
        let token = Token(kind, Substring("42"), TextLocation(1, 1))

        #expect(token.kind == kind)
    }

    @Test
    func test_location() {
        let location = TextLocation(5, 10)
        let token = Token(Kind("word"), Substring("hi"), location)

        #expect(token.location == location)
    }

    @Test
    func test_value() {
        let token = Token(Kind("word"), Substring("hello"), TextLocation(1, 1))

        #expect(token.value == "hello")
    }
}
