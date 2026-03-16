// © 2025–2026 John Gary Pusey (see LICENSE.md)

extension Tokenizer {

    // MARK: Public Nested Types

    /// A tokenizer action.
    ///
    /// An action is a closure that accepts the following parameters:
    ///
    /// - Term value:           The matching string value.
    /// - Term startCondition:  The current start condition.
    /// - Term userInfo:        The dictionary of contextual information.
    ///
    /// It returns a ``Disposition`` value or `nil`.
    public typealias Action = @Sendable (_ value: Substring,
                                         _ startCondition: StartCondition,
                                         _ userInfo: inout [UserInfoKey: any Sendable]) throws -> Disposition?
}
