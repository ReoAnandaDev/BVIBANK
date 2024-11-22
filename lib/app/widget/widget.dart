// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: camel_case_types
import 'package:bvibank/app/modules/CreditCard/views/credit_card_view.dart';
import 'package:bvibank/app/modules/Maintenance/views/maintenance_view.dart';
import 'package:bvibank/app/modules/VerifyCredit/views/verify_credit_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExClipOval extends StatelessWidget {
  final Widget icon;
  final String name;
  final Color? color;
  final VoidCallback? onTap; // Menambahkan parameter onTap

  const ExClipOval({
    Key? key,
    required this.name,
    required this.icon,
    this.color,
    this.onTap, // Menambahkan parameter onTap
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ClipOval(
          child: Material(
            color: color ?? Colors.grey, // Button color
            child: InkWell(
              splashColor: Colors.white.withOpacity(0.5), // Splash color
              highlightColor: Colors.white.withOpacity(0.2), // Highlight color
              borderRadius: BorderRadius.circular(30), // Rounded corners
              onTap: onTap, // Menggunakan onTap dari parameter
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(child: icon),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8), // Space between icon and text
        Text(
          name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            fontSize: 14, // Adjusted font size
          ),
        ),
      ],
    );
  }
}

class IconGrid extends StatefulWidget {
  @override
  _IconGridState createState() => _IconGridState();
}

class _IconGridState extends State<IconGrid> {
  bool _showAllIcons = false;

  final List<Map<String, dynamic>> _icons = [
    {
      "name": "Transfer",
      "icon": Icons.arrow_forward,
      "color": Color.fromRGBO(76, 175, 80, 1),
      "onTap": () {
        Get.to(MaintenanceView());
        print("Transfer tapped");
      },
    },
    {
      "name": "Credit",
      "icon": Icons.credit_card,
      "color": Color.fromRGBO(33, 150, 243, 1),
      "onTap": () async {
        final String uid = FirebaseAuth.instance.currentUser?.uid ?? '';

        // Fetch the approval status from Firestore
        DocumentSnapshot doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('Verifycredit')
            .doc(uid)
            .get();

        print(uid);

        if (doc.exists) {
          String approvalStatus =
              (doc.data() as Map<String, dynamic>)['approval_status'] ??
                  'Rejected';
          if (approvalStatus == 'Approved') {
            Get.to(CreditCardView());
            print("Navigating to Credit Card View");
          } else {
            Get.to(VerifyCreditView());
            print("Navigating to Verify Credit View");
          }
        } else {
          print("Document does not exist");
          // Handle the case where the document does not exist
          Get.to(VerifyCreditView()); // Fallback navigation
        }
      },
    },
    {
      "name": "Bills",
      "icon": Icons.receipt,
      "color": Color.fromRGBO(33, 150, 243, 1),
      "onTap": () {
        Get.to(MaintenanceView());
        print("Bills tapped");
      },
    },
    {
      "name": "Wallet",
      "icon": Icons.account_balance_wallet,
      "color": Color.fromRGBO(255, 193, 7, 1),
      "onTap": () {
        Get.to(MaintenanceView());
        print("Wallet tapped");
      },
    },
    {
      "name": "Reports",
      "icon": Icons.pie_chart,
      "color": Color.fromRGBO(255, 87, 34, 1),
      "onTap": () {
        Get.to(MaintenanceView());
        print("Reports tapped");
      },
    },
    {
      "name": "Invest",
      "icon": Icons.trending_up,
      "color": Color.fromRGBO(156, 39, 176, 1),
      "onTap": () {
        Get.to(MaintenanceView());
        print("Investments tapped");
      },
    },
    {
      "name": "Settings",
      "icon": Icons.settings,
      "color": Color.fromRGBO(0, 188, 212, 1),
      "onTap": () {
        Get.to(MaintenanceView());
        print("Settings tapped");
      },
    },
    {
      "name": "Loans",
      "icon": Icons.money_off,
      "color": Color.fromRGBO(255, 152, 0, 1),
      "onTap": () {
        Get.to(MaintenanceView());
        print("Loans tapped");
      },
    },
    {
      "name": "Deposit",
      "icon": Icons.attach_money,
      "color": Color.fromRGBO(76, 175, 80, 1),
      "onTap": () {
        Get.to(MaintenanceView());
        print("Deposit tapped");
      },
    },
    {
      "name": "Exchange",
      "icon": Icons.currency_exchange,
      "color": Color.fromRGBO(255, 87, 34, 1),
      "onTap": () {
        Get.to(MaintenanceView());
        print("Exchange tapped");
      },
    },
    {
      "name": "History",
      "icon": Icons.history,
      "color": Color.fromRGBO(156, 39, 176, 1),
      "onTap": () {
        Get.to(MaintenanceView());
        print("History tapped");
      },
    },
    {
      "name": "Support",
      "icon": Icons.support_agent,
      "color": Color.fromRGBO(0, 188, 212, 1),
      "onTap": () {
        Get.to(MaintenanceView());
        print("Support tapped");
      },
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Wrap(
        spacing: 16.0, // Horizontal spacing between icons
        runSpacing: 16.0, // Vertical spacing between rows
        children: List.generate(
          _showAllIcons
              ? _icons.length
              : (_icons.length > 10 ? 10 : _icons.length),
          (index) {
            if (index == 9 && _icons.length > 10) {
              return _showAllIcons
                  ? SizedBox.shrink()
                  : ExClipOval(
                      color: Colors.grey, // Color for "See All" icon
                      name: "See All",
                      icon: Icon(Icons.more_horiz, color: Colors.white),
                      onTap: () {
                        setState(() {
                          _showAllIcons = true; // Show all icons when tapped
                        });
                      },
                    );
            }
            return ExClipOval(
              color: _icons[index]['color'],
              name: _icons[index]['name'],
              icon: Icon(_icons[index]['icon'], color: Colors.white),
              onTap: _icons[index]['onTap'], // Menggunakan onTap dari daftar
            );
          },
        ),
      ),
    );
  }
}

class ExSearchBart extends StatelessWidget {
  // final String value;
  // final Function(String value) onChanged;
  // final String? label;

  const ExSearchBart({
    Key? key,
    // required this.value,
    // required this.onChanged,
    // this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(left: 28, right: 28),
      padding: const EdgeInsets.symmetric(
        vertical: 6.0,
        horizontal: 12.0,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(
          Radius.circular(42.0),
        ),
        border: Border.all(
          width: 1.0,
          color: Colors.grey[400]!,
        ),
      ),
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.search),
          ),
          Expanded(
            child: TextFormField(
              initialValue: null,
              decoration: const InputDecoration.collapsed(
                filled: true,
                fillColor: Colors.transparent,
                hintText: "Search",
                hoverColor: Colors.transparent,
              ),
              onFieldSubmitted: (value) {},
            ),
          ),
          InkWell(
            onTap: () {},
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(
                Icons.mic,
                color: Colors.blue,
                size: 20.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class QButton extends StatelessWidget {
  final String label;
  final Function onPressed;
  final double? width;
  final IconData? prefixIcon;
  final IconData? sufixIcon;
  final Color? color;
  final bool spaceBetween;

  const QButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.width,
    this.prefixIcon,
    this.sufixIcon,
    this.color,
    this.spaceBetween = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? MediaQuery.of(context).size.width,
      height: 63.0,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? const Color.fromRGBO(0, 2, 255, 100),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(22.0),
            ),
          ),
        ),
        onPressed: () => onPressed(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (prefixIcon != null) ...[
              Icon(
                prefixIcon!,
                size: 24.0,
              ),
              const SizedBox(
                width: 6.0,
              ),
            ],
            if (spaceBetween && prefixIcon != null) const Spacer(),
            Text(
              label,
              style: const TextStyle(
                fontSize: 16.0,
              ),
            ),
            if (spaceBetween && sufixIcon != null) const Spacer(),
            if (sufixIcon != null) ...[
              Icon(
                sufixIcon!,
                size: 24.0,
              ),
              const SizedBox(
                width: 6.0,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
