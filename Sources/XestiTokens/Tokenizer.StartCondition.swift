// © 2025–2026 John Gary Pusey (see LICENSE.md)

extension Tokenizer {

    // MARK: Public Nested Types

    /// A tokenizer start condition.
    public struct StartCondition {

        // MARK: Public Type Properties

        /// The singleton initial start condition.
        ///
        /// This start condition is special in that it is implied by default on
        /// all rules that do not explicitly specify start conditions. It is
        /// also active whenever an inclusive start condition is active.
        public static let initial = Self(stringValue: "",
                                         isInclusive: false,
                                         isInitial: true)!      // swiftlint:disable:this force_unwrapping

        // MARK: Public Initializers

        /// Creates a new start condition with the provided string value and the
        /// specified inclusive indication.
        ///
        /// If the provided string value is empty, this initializer stops
        /// program execution.
        ///
        /// - Parameter stringValue:    The string value to use for the new
        ///                             start condition.
        /// - Parameter isInclusive:    A Boolean value indicating whether the
        ///                             new start condition is inclusive.
        ///                             Defaults to `false`, meaning the new
        ///                             start condition will be exclusive.
        public init(_ stringValue: String,
                    isInclusive: Bool = false) {
            self.init(stringValue: stringValue,
                      isInclusive: isInclusive,
                      isInitial: false)!                        // swiftlint:disable:this force_unwrapping
        }

        /// Creates a new start condition with the provided string value and the
        /// specified inclusive indication.
        ///
        /// If the provided string value is empty, this initializer returns
        /// `nil`.
        ///
        /// - Parameter stringValue:    The string value to use for the new
        ///                             start condition.
        /// - Parameter isInclusive:    A Boolean value indicating whether the
        ///                             new start condition is inclusive.
        ///                             Defaults to `false`, meaning the new
        ///                             start condition will be exclusive.
        public init?(stringValue: String,
                     isInclusive: Bool = false) {
            self.init(stringValue: stringValue,
                      isInclusive: isInclusive,
                      isInitial: false)
        }

        // MARK: Public Instance Properties

        /// A Boolean value indicating whether this start condition is
        /// inclusive.
        ///
        /// A new start condition instance initialized with `stringValue` and
        /// `isInclusive` will be equivalent to this instance.
        public let isInclusive: Bool

        /// A Boolean value indicating whether this is the singleton initial
        /// start condition.
        public let isInitial: Bool

        /// The string value representing this start condition.
        ///
        /// A new start condition instance initialized with `stringValue` and
        /// `isInclusive` will be equivalent to this instance.
        public let stringValue: String

        // MARK: Private Initializers

        private init?(stringValue: String,
                      isInclusive: Bool,
                      isInitial: Bool) {
            guard isInitial || !stringValue.isEmpty
            else { return nil }

            self.isInclusive = isInclusive
            self.isInitial = isInitial
            self.stringValue = stringValue
        }
    }
}

// MARK: - CustomStringConvertible

extension Tokenizer.StartCondition: CustomStringConvertible {
    public var description: String {
        if isInitial {
            "«INITIAL»"
        } else if isInclusive {
            "‹" + stringValue + "›+"
        } else {
            "‹" + stringValue + "›"
        }
    }
}

// MARK: - Equatable

extension Tokenizer.StartCondition: Equatable {
}

// MARK: - Hashable

extension Tokenizer.StartCondition: Hashable {
}

// MARK: - Sendable

extension Tokenizer.StartCondition: Sendable {
}
