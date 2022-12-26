import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:hive/hive.dart';

import '../../../../config/api_config.dart';
import '../../../../constants/app_constants.dart';
import '../../../../services/dio_service.dart';
import '../models/user_auth_model.dart';
import '../models/user_model.dart';

class UserListProvider {
  final DIOService dioService = DIOService();

  Future<UserAuth> getToken() async {
    UserAuth userAuth = UserAuth();
    try {
      var data = {
        "db" : ApiConfig.db,
        "username": ApiConfig.adminUsername,
        "password": ApiConfig.adminPassword
      };
      var bodyData = json.encode(data);
      var response =
      await dioService.dio.post('/api/auth/get_tokens', data: bodyData);
      if (response.statusCode == 200) {
        var data = response.data;
        userAuth = UserAuth.fromJson(data);
        var box = await Hive.openBox(AppConstants.general_box);
        box.put(AppConstants.token_key, userAuth.accessToken);
      }
    } catch (error) {
      log('error => $error');
    }
    return userAuth;
  }

  Future<UserRes> fetchContactListData(int offset) async {
    UserRes contactListData = UserRes();
    try {
      var response = await DIOService().dio.get("/api/res.partner?limit=${ApiConfig.pageLimit}&offset=$offset");
      log('productListResponse => $response');
      if (response.statusCode == 200) {
        var data = response.data;
        contactListData = UserRes.fromJson(data);
      } else {
        log('error => responseCode is not 200');
        throw Exception("API responseCode is not 200");
      }
    } catch (error) {
      log('error => $error');
      throw Exception(error);
    }
    return contactListData;
  }
}
