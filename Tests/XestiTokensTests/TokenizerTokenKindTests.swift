// © 2025–2026 John Gary Pusey (see LICENSE.md)

import Testing
@testable import XestiTokens
import XestiTools

private typealias Kind = Tokenizer.Token.Kind

struct TokenizerTokenKindTests {
}

// MARK: -

extension TokenizerTokenKindTests {
    @Test
    func test_comparable() {
        let kind1 = Kind("alpha")
        let kind2 = Kind("beta")

        #expect(kind1 < kind2)
        #expect(!(kind2 < kind1))
    }

    @Test
    func test_description() {
        let kind = Kind("number")

        #expect(kind.description == "‹number›")
    }

    @Test
    func test_equality() {
        let kind1 = Kind("word")
        let kind2 = Kind("word")

        #expect(kind1 == kind2)
    }

    @Test
    func test_failableInitWithEmptyString() {
        let kind = Kind(stringValue: "")

        #expect(kind == nil)
    }

    @Test
    func test_failableInitWithValidString() {
        let kind = Kind(stringValue: "number")

        #expect(kind != nil)
        #expect(kind?.stringValue == "number")
    }

    @Test
    func test_hashable() {
        let kind1 = Kind("test")
        let kind2 = Kind("test")
        let kind3 = Kind("other")

        var set = Set<Kind>()

        set.insert(kind1)
        set.insert(kind2)
        set.insert(kind3)

        #expect(set.count == 2)
    }

    @Test
    func test_inequality() {
        let kind1 = Kind("word")
        let kind2 = Kind("number")

        #expect(kind1 != kind2)
    }

    @Test
    func test_nonFailableInit() {
        let kind = Kind("hello")

        #expect(kind.stringValue == "hello")
    }

    @Test
    func test_stringLiteralInit() {
        let kind: Kind = "literal"

        #expect(kind.stringValue == "literal")
    }

    @Test
    func test_stringValue() {
        let kind = Kind("myKind")

        #expect(kind.stringValue == "myKind")
    }
}
