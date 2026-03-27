// © 2025–2026 John Gary Pusey (see LICENSE.md)

import Testing
@testable import XestiTokens
import XestiTools

private typealias Disposition    = Tokenizer.Disposition
private typealias Kind           = Tokenizer.Token.Kind
private typealias StartCondition = Tokenizer.StartCondition

struct TokenizerDispositionTests {
}

// MARK: -

extension TokenizerDispositionTests {
    @Test
    func test_descriptionSaveWithCondition() {
        let disposition = Disposition.save(Kind("word"), .initial)

        #expect(disposition.description == "save(‹word›, Optional(«INITIAL»))")
    }

    @Test
    func test_descriptionSaveWithNilCondition() {
        let disposition = Disposition.save(Kind("word"), nil)

        #expect(disposition.description == "save(‹word›, nil)")
    }

    @Test
    func test_descriptionSkipWithCondition() {
        let condition = StartCondition("other")
        let disposition = Disposition.skip(condition)

        #expect(disposition.description == "skip(Optional(‹other›))")
    }

    @Test
    func test_descriptionSkipWithNilCondition() {
        let disposition = Disposition.skip(nil)

        #expect(disposition.description == "skip(nil)")
    }
}
