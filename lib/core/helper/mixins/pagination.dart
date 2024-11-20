import 'package:flutter/material.dart';

mixin PaginationMixin {
  late ScrollController scrollController;
  bool isLoading = false;
  bool stopLoading = false;
  int currentPage = 1;
  double boundaryOffset = 0.8;
  late Function loadAction;

  void initPagination({Function? initAction, required Function loadAction}) {
    if (initAction != null) {
      initAction();
    }
    this.loadAction = loadAction;
    scrollController = ScrollController()..addListener(scrollListener);
  }

  void disposePagination() {
    scrollController.removeListener(scrollListener);
    scrollController.dispose();
  }

  void scrollListener() {
    if (!stopLoading) {
      if (scrollController.offset >=
              scrollController.position.maxScrollExtent * boundaryOffset &&
          !isLoading) {
        isLoading = true;
        loadAction().then((shouldStop) {
          isLoading = false;
          currentPage++;
          boundaryOffset = 1 - 1 / (currentPage * 2);
          if (shouldStop == true) {
            stopLoading = true;
          }
        });
      }
    }
  }

  void resetPagination() {
    currentPage = 1;
    stopLoading = false;
  }
}
