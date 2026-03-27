// © 2025–2026 John Gary Pusey (see LICENSE.md)

import Testing
@testable import XestiTokens
import XestiTools

private typealias UserInfoKey = Tokenizer.UserInfoKey

struct TokenizerUserInfoKeyTests {
}

// MARK: -

extension TokenizerUserInfoKeyTests {
    @Test
    func test_equality() {
        let key1 = UserInfoKey("test")
        let key2 = UserInfoKey("test")

        #expect(key1 == key2)
    }

    @Test
    func test_failableInitWithEmptyString() {
        let key = UserInfoKey(stringValue: "")

        #expect(key == nil)
    }

    @Test
    func test_failableInitWithValidString() {
        let key = UserInfoKey(stringValue: "myKey")

        #expect(key != nil)
        #expect(key?.stringValue == "myKey")
    }

    @Test
    func test_hashable() {
        let key1 = UserInfoKey("test")
        let key2 = UserInfoKey("test")
        let key3 = UserInfoKey("other")

        var set = Set<UserInfoKey>()

        set.insert(key1)
        set.insert(key2)
        set.insert(key3)

        #expect(set.count == 2)
    }

    @Test
    func test_inequality() {
        let key1 = UserInfoKey("alpha")
        let key2 = UserInfoKey("beta")

        #expect(key1 != key2)
    }

    @Test
    func test_nonFailableInit() {
        let key = UserInfoKey("myKey")

        #expect(key.stringValue == "myKey")
    }

    @Test
    func test_stringValue() {
        let key = UserInfoKey("hello")

        #expect(key.stringValue == "hello")
    }
}
