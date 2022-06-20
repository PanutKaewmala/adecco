import 'package:ahead_adecco/src/config/export_config.dart';
import 'package:ahead_adecco/src/pages/merchandising/select_shop/select_shop_ctrl.dart';
import 'package:ahead_adecco/src/widgets/export_widget.dart';

import 'select_shop_widget.dart';

class SelectShopPage extends StatelessWidget {
  const SelectShopPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SelectShopController controller =
        Get.put(SelectShopController(context));
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
                  (state) => buildShopList(controller, state!),
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
