import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:get/get.dart';

import '../../../../config/api_config.dart';
import '../controllers/user_list_controller.dart';
import 'contact_item_view.dart';

class UserListView extends GetView<UserListController> {
  UserListView({Key? key}) : super(key: key);

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: controller.isLoadingProgress.value
            ? const Center(
          child: CircularProgressIndicator.adaptive(),
        )
            : RefreshIndicator(
            key: _refreshIndicatorKey,
            onRefresh: controller.refreshContactList,
            child: NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (!controller.isRefreshing.value &&
                    !controller.isPagingLoading.value &&
                    scrollInfo.metrics.pixels ==
                        scrollInfo.metrics.maxScrollExtent &&
                    controller.scrollController.position
                        .userScrollDirection ==
                        ScrollDirection.reverse) {
                  if(!controller.hasReachedMax.value) {
                    controller.offset.value += ApiConfig.pageLimit;
                    controller.isPagingLoading.value = true;
                    controller.fetchContactList();
                  }
                }

                if (!controller.isRefreshing.value &&
                    !controller.isPagingLoading.value &&
                    controller.scrollController.position
                        .userScrollDirection ==
                        ScrollDirection.forward &&
                    scrollInfo.metrics.pixels ==
                        scrollInfo.metrics.minScrollExtent) {
                  _refreshIndicatorKey.currentState?.show();
                }

                return true;
              },
              child: ListView.separated(
                scrollDirection: Axis.vertical,
                controller: controller.scrollController,
                itemCount:
                controller.contactListData.value.results!.length,
                separatorBuilder: (context, index) {
                  return const SizedBox(
                    height: 0,
                  );
                },
                itemBuilder: (context, index) {
                  return ContactItem(
                    controller.contactListData.value.results![index],
                    onTap: () {
                    },
                  );
                },
              ),
            )),
      ),
      bottomNavigationBar: Visibility(
          visible: controller.isPagingLoading.value,
          child: const LinearProgressIndicator()),
    ));
  }
}
