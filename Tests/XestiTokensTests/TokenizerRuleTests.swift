// © 2025–2026 John Gary Pusey (see LICENSE.md)

import Testing
@testable import XestiTokens
import XestiTools

private typealias Kind = Tokenizer.Token.Kind
private typealias Rule = Tokenizer.Rule

struct TokenizerRuleTests {
}

// MARK: -

extension TokenizerRuleTests {
    @Test
    func test_convenienceInit() throws {
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
    func test_defaultStartConditions() {
        let rule = Rule(/[a-z]+/, Kind("word"))

        #expect(rule.startConditions == [.initial])
    }

    @Test
    func test_description() {
        let rule = Rule(/[a-z]+/, Kind("word"))
        let desc = rule.description

        #expect(desc.contains("[«INITIAL»]"))
        #expect(desc.contains("save(‹word›, nil)"))
    }

    @Test
    func test_equalitySameRule() {
        let rule = Rule(/[a-z]+/, Kind("word"))

        #expect(rule == rule)   // swiftlint:disable:this identical_operands
    }

    @Test
    func test_fullInit() {
        let condition = Tokenizer.StartCondition("test")
        let rule = Rule(regex: /[a-z]+/,
                        startConditions: [.initial, condition],
                        disposition: .save(Kind("word"), nil)) { _, _, _ in
            nil
        }

        #expect(rule.startConditions.count == 2)
        #expect(rule.startConditions.contains(.initial))
        #expect(rule.startConditions.contains(condition))
    }

    @Test
    func test_hashable() {
        let rule1 = Rule(/[a-z]+/, Kind("word"))
        let rule2 = Rule(/[0-9]+/, Kind("number"))

        var set = Set<Rule>()

        set.insert(rule1)
        set.insert(rule1)
        set.insert(rule2)

        #expect(set.count == 2)
    }

    @Test
    func test_inequalityDifferentRules() {
        let rule1 = Rule(/[a-z]+/, Kind("word"))
        let rule2 = Rule(/[a-z]+/, Kind("word"))

        #expect(rule1 != rule2)
    }

    @Test
    func test_isActiveForExclusiveCondition() {
        let exclusive = Tokenizer.StartCondition("exclusive")
        let ruleForExclusive = Rule(regex: /[a-z]+/,
                                    startConditions: [exclusive],
                                    disposition: .save(Kind("word"), nil))
        let ruleForInitial = Rule(/[a-z]+/, Kind("word"))

        #expect(ruleForExclusive.isActive(for: exclusive))
        #expect(!ruleForExclusive.isActive(for: .initial))
        #expect(!ruleForInitial.isActive(for: exclusive))
    }

    @Test
    func test_isActiveForInclusiveCondition() {
        let inclusive = Tokenizer.StartCondition("inclusive",
                                                 isInclusive: true)
        let ruleForInitial = Rule(/[a-z]+/, Kind("word"))
        let ruleForInclusive = Rule(regex: /[0-9]+/,
                                    startConditions: [inclusive],
                                    disposition: .save(Kind("number"), nil))

        #expect(ruleForInitial.isActive(for: inclusive))
        #expect(ruleForInclusive.isActive(for: inclusive))
    }

    @Test
    func test_isActiveForInitialCondition() {
        let rule = Rule(/[a-z]+/, Kind("word"))

        #expect(rule.isActive(for: .initial))
    }
}
