// © 2025–2026 John Gary Pusey (see LICENSE.md)

import Testing
@testable import XestiTokens
import XestiTools

struct TokenizerErrorTests {
}

// MARK: -

extension TokenizerErrorTests {
    @Test
    func test_message() {
        let value = Substring("abc")
        let location = TextLocation(1, 5)
        let error = Tokenizer.Error.unrecognizedToken(value, location)

        #expect(error.message == "Unrecognized token beginning: «abc», line: 1, column: 5")
    }
}
