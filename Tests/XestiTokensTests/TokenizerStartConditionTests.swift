// © 2025–2026 John Gary Pusey (see LICENSE.md)

import Testing
@testable import XestiTokens

private typealias StartCondition = Tokenizer.StartCondition

struct TokenizerStartConditionTests {
}

// MARK: -

extension TokenizerStartConditionTests {
    @Test
    func test_customExclusiveDescription() {
        let condition = StartCondition("custom")

        #expect(condition.description == "‹custom›")
    }

    @Test
    func test_customInclusiveDescription() {
        let condition = StartCondition("custom",
                                       isInclusive: true)

        #expect(condition.description == "‹custom›+")
    }

    @Test
    func test_equality() {
        let cond1 = StartCondition("test")
        let cond2 = StartCondition("test")

        #expect(cond1 == cond2)
    }

    @Test
    func test_failableInitWithEmptyString() {
        let condition = StartCondition(stringValue: "")

        #expect(condition == nil)
    }

    @Test
    func test_failableInitWithValidString() {
        let condition = StartCondition(stringValue: "test")

        #expect(condition != nil)
        #expect(condition?.stringValue == "test")
    }

    @Test
    func test_hashable() {
        let cond1 = StartCondition("test")
        let cond2 = StartCondition("test")
        let cond3 = StartCondition("other")

        var set = Set<StartCondition>()

        set.insert(cond1)
        set.insert(cond2)
        set.insert(cond3)

        #expect(set.count == 2)
    }

    @Test
    func test_inequality() {
        let cond1 = StartCondition("alpha")
        let cond2 = StartCondition("beta")

        #expect(cond1 != cond2)
    }

    @Test
    func test_inequalityDifferentInclusivity() {
        let cond1 = StartCondition("test")
        let cond2 = StartCondition("test",
                                   isInclusive: true)

        #expect(cond1 != cond2)
    }

    @Test
    func test_initialDescription() {
        #expect(StartCondition.initial.description == "«INITIAL»")
    }

    @Test
    func test_initialIsNotInclusive() {
        #expect(!StartCondition.initial.isInclusive)
    }

    @Test
    func test_initialIsNotNil() {
        #expect(StartCondition.initial.isInitial)
    }

    @Test
    func test_isInclusiveDefault() {
        let condition = StartCondition("test")

        #expect(!condition.isInclusive)
    }

    @Test
    func test_isInitialFalseForCustomCondition() {
        let condition = StartCondition("custom")

        #expect(!condition.isInitial)
    }

    @Test
    func test_nonFailableInit() {
        let condition = StartCondition("test",
                                       isInclusive: true)

        #expect(condition.stringValue == "test")
        #expect(condition.isInclusive)
    }
}
