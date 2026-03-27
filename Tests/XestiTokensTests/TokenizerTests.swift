// © 2025–2026 John Gary Pusey (see LICENSE.md)

import Testing
@testable import XestiTokens
import XestiTools

private typealias Kind           = Tokenizer.Token.Kind
private typealias Rule           = Tokenizer.Rule
private typealias StartCondition = Tokenizer.StartCondition

struct TokenizerTests {
}

// MARK: -

extension TokenizerTests {
    @Test
    func test_actionReturnsDisposition() throws {
        let actionKind: Kind = "custom"
        let rule = Rule(regex: /[a-z]+/) { _, _, _ in
            .save(actionKind, nil)
        }
        let tokenizer = Tokenizer(rules: [rule],
                                  tracing: .silent)
        let tokens = try tokenizer.tokenize(input: "hello")

        #expect(tokens.count == 1)
        #expect(tokens[0].kind == actionKind)
        #expect(tokens[0].value == "hello")
    }

    @Test
    func test_actionUserInfo() throws {
        let counterKey = Tokenizer.UserInfoKey("counter")
        let kind: Kind = "word"
        let rule = Rule(regex: /[a-z]+/) { _, _, userInfo in
            let count = (userInfo[counterKey] as? Int) ?? 0

            userInfo[counterKey] = count + 1

            return .save(kind, nil)
        }
        let skipRule = Rule(regex: /\s+/,
                            disposition: .skip(nil))
        let tokenizer = Tokenizer(rules: [rule, skipRule],
                                  userInfo: [counterKey: 0],
                                  tracing: .silent)
        let tokens = try tokenizer.tokenize(input: "a b c")

        #expect(tokens.count == 3)
    }

    @Test
    func test_emptyInput() throws {
        let rule = Rule(/[a-z]+/, Kind("word"))
        let tokenizer = Tokenizer(rules: [rule],
                                  tracing: .silent)
        let tokens = try tokenizer.tokenize(input: "")

        #expect(tokens.isEmpty)
    }

    @Test
    func test_initDefaultProperties() {
        let rules: [Rule] = [Rule(/[a-z]+/, Kind("word"))]
        let tokenizer = Tokenizer(rules: rules)

        #expect(tokenizer.rules.count == 1)
        #expect(tokenizer.tracing == .silent)
        #expect(tokenizer.userInfo.isEmpty)
    }

    @Test
    func test_initWithAllParameters() {
        let infoKey = Tokenizer.UserInfoKey("test")
        let rules: [Rule] = [Rule(/[a-z]+/, Kind("word"))]
        let tokenizer = Tokenizer(rules: rules,
                                  userInfo: [infoKey: "value"],
                                  tracing: .verbose)

        #expect(tokenizer.rules.count == 1)
        #expect(tokenizer.tracing == .verbose)
        #expect(tokenizer.userInfo.count == 1)
        #expect(tokenizer.userInfo[infoKey] as? String == "value")
    }

    @Test
    func test_longestMatchWins() throws {
        let shortRule = Rule(/[a-z]/, Kind("short"))
        let longRule = Rule(/[a-z]+/, Kind("long"))
        let tokenizer = Tokenizer(rules: [shortRule, longRule],
                                  tracing: .silent)
        let tokens = try tokenizer.tokenize(input: "hello")

        #expect(tokens.count == 1)
        #expect(tokens[0].kind == Kind("long"))
        #expect(tokens[0].value == "hello")
    }

    @Test
    func test_multipleTokens() throws {
        let kind: Kind = "word"
        let wordRule = Rule(/[a-z]+/, kind)
        let spaceRule = Rule(regex: /\s+/,
                             disposition: .skip(nil))
        let tokenizer = Tokenizer(rules: [wordRule, spaceRule],
                                  tracing: .silent)
        let tokens = try tokenizer.tokenize(input: "hello world")

        #expect(tokens.count == 2)
        #expect(tokens[0].kind == kind)
        #expect(tokens[0].value == "hello")
        #expect(tokens[1].kind == kind)
        #expect(tokens[1].value == "world")
    }

    @Test
    func test_noDispositionSkipsToken() throws {
        let rule = Rule(regex: /[a-z]+/)
        let tokenizer = Tokenizer(rules: [rule],
                                  tracing: .silent)
        let tokens = try tokenizer.tokenize(input: "hello")

        #expect(tokens.isEmpty)
    }

    @Test
    func test_singleToken() throws {
        let kind: Kind = "word"
        let rule = Rule(/[a-z]+/, kind)
        let tokenizer = Tokenizer(rules: [rule],
                                  tracing: .silent)
        let tokens = try tokenizer.tokenize(input: "hello")

        #expect(tokens.count == 1)
        #expect(tokens[0].kind == kind)
        #expect(tokens[0].value == "hello")
    }

    @Test
    func test_skipDisposition() throws {
        let kind: Kind = "word"
        let wordRule = Rule(/[a-z]+/, kind)
        let spaceRule = Rule(regex: /\s+/,
                             disposition: .skip(nil))
        let tokenizer = Tokenizer(rules: [wordRule, spaceRule],
                                  tracing: .silent)
        let tokens = try tokenizer.tokenize(input: "  hello  ")

        #expect(tokens.count == 1)
        #expect(tokens[0].value == "hello")
    }

    @Test
    func test_startConditionExclusive() throws {
        let wordKind: Kind = "word"
        let tagKind: Kind = "tag"
        let tagMode = StartCondition("tag")
        let wordRule = Rule(regex: /[a-z]+/,
                            startConditions: [.initial],
                            disposition: .save(wordKind, nil))
        let tagRule = Rule(regex: /[a-z]+/,
                           startConditions: [tagMode],
                           disposition: .save(tagKind, nil))
        let openRule = Rule(regex: /</,
                            startConditions: [.initial],
                            disposition: .skip(tagMode))
        let closeRule = Rule(regex: />/,
                             startConditions: [tagMode],
                             disposition: .skip(.initial))
        let tokenizer = Tokenizer(rules: [wordRule, tagRule, openRule, closeRule],
                                  tracing: .silent)
        let tokens = try tokenizer.tokenize(input: "hello<world>")

        #expect(tokens.count == 2)
        #expect(tokens[0].kind == wordKind)
        #expect(tokens[0].value == "hello")
        #expect(tokens[1].kind == tagKind)
        #expect(tokens[1].value == "world")
    }

    @Test
    func test_unrecognizedTokenError() {
        let rule = Rule(/[a-z]+/, Kind("word"))
        let tokenizer = Tokenizer(rules: [rule],
                                  tracing: .silent)

        #expect(throws: Tokenizer.Error.self) {
            try tokenizer.tokenize(input: "123")
        }
    }
}
