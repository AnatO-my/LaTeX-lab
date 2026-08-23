"""Domain errors for OT Math."""


class OTMathError(Exception):
    """Base class for all OT Math errors."""


class MathParseError(OTMathError):
    """Raised when an expression cannot be parsed safely."""


class MathRequestError(OTMathError):
    """Raised when a structured math request is invalid."""


class AIProviderError(OTMathError):
    """Raised when an optional AI provider fails or returns invalid output."""


class UnsupportedOperationError(OTMathError):
    """Raised when an operation is not supported by the current engine."""
