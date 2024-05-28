enum Failure {socketFailure, authFailure, severFailure, firebaseFailure, unknownFailure, noData}
class DataCRUDFailure {
  final Failure failure;
  final String message;

  DataCRUDFailure({required this.failure, required this.message});
}