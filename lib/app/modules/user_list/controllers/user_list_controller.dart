import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../../../../config/api_config.dart';
import '../../../../constants/app_constants.dart';
import '../models/user_model.dart';
import '../providers/user_list_provider.dart';

class UserListController extends GetxController {
  var listBox = Hive.box(AppConstants.user_list_box);

  final isLoadingProgress = true.obs;
  final UserListProvider contactListProvider = UserListProvider();
  final contactListData = UserRes().obs;

  var isPagingLoading = false.obs;
  var offset = 0.obs;

  final ScrollController scrollController = ScrollController();
  final isRefreshing = false.obs;
  final hasReachedMax = false.obs;

  @override
  void onInit() async {
    super.onInit();

    await contactListProvider.getToken();
    fetchContactList();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> refreshContactList() async {
    await Future.delayed(const Duration(seconds: 1));
    isRefreshing(true);
    offset.value = 0;
    hasReachedMax(false);
    await fetchContactList();
    isRefreshing(false);
  }

  Future<void> fetchContactList() async {
    contactListProvider.fetchContactListData(offset.value).then(
      (value) async {
        if (offset > 0) {
          value.results?.forEach((element) {
            contactListData.value.results?.add(element);
          });
        } else {
          contactListData.value = value;
        }
        listBox.put(AppConstants.user_list_data_box, jsonEncode(contactListData.value));
        contactListData.value = UserRes.fromJson(jsonDecode(listBox.get(AppConstants.user_list_data_box)));

        if ((value.count ?? 0) < ApiConfig.pageLimit) {
          hasReachedMax(true);
        }
        isPagingLoading(false);
        isLoadingProgress(false);
      },
    ).catchError((error) async{
      log('fetchMarketplaceError $error');
      print("fetchMarketplaceError= >>  ${listBox.values.length}");
      contactListData.value = UserRes.fromJson(jsonDecode(listBox.get(AppConstants.user_list_data_box)));
      isPagingLoading(false);
      isLoadingProgress(false);
      hasReachedMax(true);
    });
  }
}
