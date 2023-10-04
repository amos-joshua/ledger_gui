
class UserFacingError {
  final String message;
  final StackTrace? stackTrace;
  const UserFacingError({required this.message, this.stackTrace});
}