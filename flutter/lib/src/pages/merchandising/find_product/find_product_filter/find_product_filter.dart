import 'package:ahead_adecco/src/config/export_config.dart';
import 'package:ahead_adecco/src/constants/export_constants.dart';

import 'package:ahead_adecco/src/widgets/export_widget.dart';

import '../find_product_widget.dart';
import 'find_product_filter_ctrl.dart';

class FindProductFilterPage extends StatelessWidget {
  FindProductFilterPage({Key? key}) : super(key: key);
  final FindProductType _type = Get.arguments[Keys.type];
  final int _merchandisingID = Get.arguments[Keys.id];
  final int? _parentID = Get.arguments[Keys.parentID];

  @override
  Widget build(BuildContext context) {
    final FindProductFilterController controller = Get.put(
        FindProductFilterController(context,
            type: _type,
            merchandisingID: _merchandisingID,
            parentID: _parentID));
    return KeyboardDismisser(
      child: Obx(
        () => Scaffold(
          appBar: appbarBackgroundWithSearch("Select shop",
              subTitle: "Manage Products",
              showSearch: controller.showSearch.value,
              textEditingController: controller.textSearch, onChanged: (value) {
            controller.onSearchChanged(value);
          },
              action: IconButton(
                icon: Icon(
                  controller.showSearch.value ? Icons.close : Icons.search,
                  color: AppTheme.white,
                ),
                onPressed: () {
                  controller.onClickClear();
                },
              )),
          body: Column(
            children: [
              Expanded(
                child: controller.obx(
                  (state) => buildFilterList(controller, state!),
                  onLoading: controller.showSearch.value
                      ? Container()
                      : Center(child: LoadingCustom.loadingWidget()),
                  onEmpty: Center(child: textNotFoundAndIcon()),
                  onError: (error) => Center(child: textErrorAndIcon()),
                ),
              ),
              if (controller.isLoading.value == true && controller.page != 1)
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: Center(
                    child: LoadingCustom.loadingWidget(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
