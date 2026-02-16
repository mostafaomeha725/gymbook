enum RequestState { init, loading, success, error }

extension RequestStateX on RequestState {
  bool get isLoading => this == RequestState.loading;
  bool get isSuccess => this == RequestState.success;
  bool get isError => this == RequestState.error;
}
