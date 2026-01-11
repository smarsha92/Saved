import Foundation

/// Utility for validating and normalizing URLs
public struct URLValidator {

    /// Validates if a string is a valid URL
    /// - Parameter urlString: The string to validate
    /// - Returns: True if the string is a valid URL
    public static func isValidURL(_ urlString: String) -> Bool {
        let trimmed = urlString.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return false }

        // Try to create a URL with the string as-is
        if let url = URL(string: trimmed), isValidURLComponents(url) {
            return true
        }

        // Try adding https:// prefix
        let withHTTPS = "https://" + trimmed
        if let url = URL(string: withHTTPS), isValidURLComponents(url) {
            return true
        }

        return false
    }

    /// Checks if URL has valid components (scheme and host)
    private static func isValidURLComponents(_ url: URL) -> Bool {
        guard let scheme = url.scheme,
              let host = url.host,
              !host.isEmpty else {
            return false
        }

        // Only allow http and https schemes
        let validSchemes = ["http", "https"]
        guard validSchemes.contains(scheme.lowercased()) else {
            return false
        }

        // Host must contain at least one dot (e.g., example.com)
        // Exception for localhost
        if host == "localhost" {
            return true
        }

        guard host.contains(".") else {
            return false
        }

        // Validate host doesn't start or end with a dot
        guard !host.hasPrefix(".") && !host.hasSuffix(".") else {
            return false
        }

        return true
    }

    /// Normalizes a URL string by adding https:// if no scheme is present
    /// - Parameter urlString: The string to normalize
    /// - Returns: The normalized URL string, or nil if invalid
    public static func normalizeURL(_ urlString: String) -> String? {
        let trimmed = urlString.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }

        // If already has a valid scheme, return as-is
        if let url = URL(string: trimmed),
           let scheme = url.scheme,
           ["http", "https"].contains(scheme.lowercased()),
           isValidURLComponents(url) {
            return trimmed
        }

        // Try adding https://
        let withHTTPS = "https://" + trimmed
        if let url = URL(string: withHTTPS), isValidURLComponents(url) {
            return withHTTPS
        }

        return nil
    }

    /// Validation result with detailed error information
    public enum ValidationResult {
        case valid(normalizedURL: String)
        case invalid(reason: String)

        public var isValid: Bool {
            switch self {
            case .valid: return true
            case .invalid: return false
            }
        }

        public var normalizedURL: String? {
            switch self {
            case .valid(let url): return url
            case .invalid: return nil
            }
        }

        public var errorMessage: String? {
            switch self {
            case .valid: return nil
            case .invalid(let reason): return reason
            }
        }
    }

    /// Validates a URL and returns detailed result
    /// - Parameter urlString: The string to validate
    /// - Returns: ValidationResult with status and details
    public static func validate(_ urlString: String) -> ValidationResult {
        let trimmed = urlString.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmed.isEmpty else {
            return .invalid(reason: "Please enter a URL")
        }

        if let normalized = normalizeURL(trimmed) {
            return .valid(normalizedURL: normalized)
        }

        return .invalid(reason: "Please enter a valid URL")
    }
}
