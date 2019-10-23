
class Resource<T>{
  final T data;
  final Object message;
  final Status status;
  bool isHandled = false;

  Resource(this.data, this.message, this.status);
  factory Resource.success(T data){
    return Resource(data,null,Status.Success);
  }

  factory  Resource.loading({T data = null}) {
    return Resource(data, null, Status.Loading);
  }

  factory  Resource.error(Object message,{T data = null}) {
    return Resource(data, message, Status.Error);
  }

}

enum Status{
  Loading,
  Error,
  Success
}