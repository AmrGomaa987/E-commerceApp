import 'package:ecommerce_app_with_flutter/common/widget/appbar/app_bar.dart';
import 'package:ecommerce_app_with_flutter/presentation/settings/widgets/logout_tile.dart';
import 'package:ecommerce_app_with_flutter/presentation/settings/widgets/my_orders_tile.dart';
import 'package:flutter/material.dart';

import '../widgets/my_favorties_tile.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: BasicAppbar(title: Text('Settings')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            MyFavortiesTile(),
            SizedBox(height: 15),
            MyOrdersTile(),
            SizedBox(height: 15),
            LogoutTile(),
          ],
        ),
      ),
    );
  }
}
