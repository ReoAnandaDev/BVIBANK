import 'package:bvibank/app/modules/Notification/views/notification_view.dart';
import 'package:bvibank/app/widget/widget.dart';
import 'package:bvibank/app/widgets/app_large_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:u_credit_card/u_credit_card.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    // Pastikan controller di-instantiate
    Get.lazyPut(() => HomeController());
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/image/backgroundfinger.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Content
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.only(top: 60.0, left: 20.0, right: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                          onPressed: () {
                            Get.to(NotificationView());
                          },
                          icon: Icon(Icons.notifications,
                              size: 30, color: Colors.black54)),
                    ],
                  ),
                ),
                const SizedBox(height: 20.0),
                // Discover
                Container(
                  margin: const EdgeInsets.only(left: 20.0),
                  child: Obx(() => AppLargeText(
                      text: "Welcome, ${controller.fullName.value}",
                      size: 24,
                      color: Colors.black87)),
                ),
                const SizedBox(height: 20.0),
                // Credit Card
                Center(
                  child: Obx(() => CreditCardUi(
                        currencySymbol: 'Rp',
                        cardHolderFullName: controller.fullName.value,
                        cardNumber: controller.cardNumber.value,
                        validFrom: controller.validFrom.value,
                        validThru: controller.validThru.value,
                        topLeftColor: Colors.blueAccent,
                        doesSupportNfc: true,
                        placeNfcIconAtTheEnd: true,
                        cardType: CardType.debit,
                        cardProviderLogo: Image.asset('images/logo/logo.png'),
                        cardProviderLogoPosition:
                            CardProviderLogoPosition.right,
                        showBalance: true,
                        balance: controller.balance.value,
                        autoHideBalance: true,
                        enableFlipping: true,
                        cvvNumber: '***',
                      )),
                ),
                const SizedBox(height: 20.0),
                // Icon Grid
                Center(
                  child: IconGrid(),
                ),
                const SizedBox(height: 20.0),
                // TabBar
                Center(
                  child: Container(
                    child: TabBar(
                      indicatorPadding: const EdgeInsets.only(bottom: 5.0),
                      controller: controller.tabController,
                      labelColor: Colors.blueAccent,
                      unselectedLabelColor: Colors.grey,
                      isScrollable: true,
                      indicatorSize: TabBarIndicatorSize.label,
                      indicator: CircleTabIndicator(
                          color: Colors.blueAccent, radius: 4),
                      tabs: const [
                        Tab(text: "News"),
                        Tab(text: "Promo"),
                        Tab(text: "Investasi"),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 250,
                  width: double.maxFinite,
                  margin: const EdgeInsets.only(top: 10.0),
                  child: TabBarView(
                    controller: controller.tabController,
                    children: [
                      buildListView(controller.news),
                      buildListView(controller.promo),
                      buildListView(controller.invest),
                    ],
                  ),
                ),
                const SizedBox(height: 20.0),
                // Contact Person
                Container(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  margin: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppLargeText(
                          text: "Contact Person",
                          size: 20,
                          color: Colors.black87),
                      Card(
                        elevation: 6,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        child: ListTile(
                          leading: const CircleAvatar(
                            backgroundImage:
                                AssetImage("images/icons/avatar-design.png"),
                          ),
                          title: const Text("Reo Rizki Ananda",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: const Text("0813 7013 6405"),
                          trailing: IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.call,
                                size: 24.0, color: Colors.blueAccent),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildListView(RxList<String> items) {
    return SizedBox(
      height: 80.0,
      child: Obx(() => ListView.builder(
            itemCount: items.length,
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.zero,
            clipBehavior: Clip.none,
            itemBuilder: (_, index) {
              return Container(
                width: 570.0,
                margin: EdgeInsets.only(
                  top: 15.0,
                  bottom: 15.0,
                  left: index == 0 ? 20.0 : 10.0,
                  right: index == items.length - 1 ? 20.0 : 0.0,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage("images/image/" + items[index]),
                  ),
                ),
              );
            },
          )),
    );
  }
}

// ignore: must_be_immutable
class CircleTabIndicator extends Decoration {
  final Color color;
  double radius;
  CircleTabIndicator({required this.color, this.radius = 3.0});

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _CirclePainter(color: color, radius: radius);
  }
}

class _CirclePainter extends BoxPainter {
  final Color color;
  double radius;
  _CirclePainter({
    required this.color,
    required this.radius,
  });

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration cfg) {
    Paint paint = Paint();
    paint.color = color;
    paint.isAntiAlias = true;

    final Offset circleOffset =
        Offset(cfg.size!.width / 2 - radius / 2, cfg.size!.height - radius);

    canvas.drawCircle(offset + circleOffset, radius, paint);
  }
}
