/// Standard return of services: a broken rule or an expected failure is a
/// [Failure], not an exception.
sealed class Result<Data> {
  const Result();
}

final class Success<Data> extends Result<Data> {
  const Success(this.data);

  final Data data;
}

final class Failure<Data> extends Result<Data> {
  const Failure(this.message);

  /// Ready to be shown to the user.
  final String message;
}
