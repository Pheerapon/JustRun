class DataResponse<T> {
  DataResponse.loading(this.message) : status = Status.Loading;

  DataResponse.success(this.data) : status = Status.Success;

  DataResponse.error(this.message) : status = Status.Error;

  DataResponse.connectivityError() : status = Status.ConnectivityError;
  Status status;
  T data;
  String message;

  @override
  String toString() {
    return 'Status : $status \n Message : $message \n Data : $data';
  }
}

enum Status { Loading, Success, Error, ConnectivityError }
