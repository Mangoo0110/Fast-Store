enum Failure {socketFailure, authFailure, severFailure, firebaseFailure, unknownFailure, outOfMemoryError, noData}
class DataCRUDFailure {
  final Failure failure;
  final String message;

  DataCRUDFailure({required this.failure, required this.message});
}