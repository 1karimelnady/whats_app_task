import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final TabController? tabController;
  final List<String>? tabs;

  const CustomAppBar({
    super.key,
    required this.title,
    this.tabController,
    this.tabs,
  });

  @override
  Size get preferredSize => Size.fromHeight(tabs != null ? 120 : 56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      actions: [
        IconButton(icon: const Icon(Icons.search), onPressed: () {}),
        IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
      ],
      bottom: tabs != null
          ? TabBar(
              controller: tabController,
              tabs: tabs!.map((tab) => Tab(text: tab)).toList(),
              indicatorColor: Colors.white,
              indicatorWeight: 3,
            )
          : null,
    );
  }
}
