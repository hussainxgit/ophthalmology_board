class DataResponse {
  String? errorMessage, successMessage;
  bool onError = false;
  bool onSuccess = false;
  Object? object;

  setError(String errorMessage) =>
      {onError = true, this.errorMessage = errorMessage};

  setSuccess(String successMessage, [Object? object]) => {
        errorMessage = null,
        onError = false,
        onSuccess = true,
        this.successMessage = successMessage,
        this.object = object
  };
}
