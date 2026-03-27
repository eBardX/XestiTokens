// © 2025–2026 John Gary Pusey (see LICENSE.md)

internal import XestiTools

private import Foundation

extension Substring {

    // MARK: Internal Instance Methods

    internal func escapedPrefix(maxLength: Int = 16,
                                openQuote: String = "«",
                                closeQuote: String = "»",
                                location: TextLocation? = nil) -> String {
        var result = openQuote

        if count > maxLength {
            result += liteEscape(prefix(maxLength)) + "…"
        } else {
            result += liteEscape(self)
        }

        result += closeQuote

        if let location {
            result += ", line: "
            result += location.line.formatted()
            result += ", column: "
            result += location.column.formatted()
        }

        return result
    }
}
