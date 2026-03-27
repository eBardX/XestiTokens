// © 2025–2026 John Gary Pusey (see LICENSE.md)

import Testing
@testable import XestiTokens

private typealias RuleID = Tokenizer.Rule.ID

struct TokenizerRuleIDTests {
}

// MARK: -

extension TokenizerRuleIDTests {
    @Test
    func test_descriptionPrefix() {
        let ruleID = RuleID()

        #expect(ruleID.description.hasPrefix("R$"))
    }

    @Test
    func test_equalitySameInstance() {
        let ruleID = RuleID()

        #expect(ruleID == ruleID)   // swiftlint:disable:this identical_operands
    }

    @Test
    func test_hashable() {
        let ruleID = RuleID()

        var set = Set<RuleID>()

        set.insert(ruleID)
        set.insert(ruleID)

        #expect(set.count == 1)
    }

    @Test
    func test_uniqueness() {
        let ruleID1 = RuleID()
        let ruleID2 = RuleID()

        #expect(ruleID1 != ruleID2)
    }
}
