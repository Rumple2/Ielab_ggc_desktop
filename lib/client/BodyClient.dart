import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ggc_desktop/client/list_client.dart';

import '../Statistic/Board.dart';

class BodyClient extends StatelessWidget {
  const BodyClient({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(flex: 2, child: GlobalBoard()),
        Expanded(
          flex: 8,
          child: ListClient(),
        ),
      ],
    );
  }
}
