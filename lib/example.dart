class BaseAPI {
  /* This is the route of the api of the system */
  static var rootUrl = "http://192.168.0.152:8000/";
  static var api = "${rootUrl}api/";

  /* This is the routes of the system's API */
  var getItems = "${api}test/";
  var getCategories = "${api}getCategories/";
  var order = "${api}order/";
  var fetchOrder = "${api}getOrder/";
  var passOrder = "${api}order/passOrder/";
  var login = "${api}login/";
  var getTable = "${api}table/";
  var deleteOrder = "${api}order/";
  var user = "${api}user/";
  var statusUrl = "${api}order/status/";
  var langauges = "${api}language";
  static var images = "${rootUrl}storage/images/";
}
