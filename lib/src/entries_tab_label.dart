import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'model/model.dart';

class EntriesTabLabel extends StatefulWidget {
  final int index;
  final String label;
  final void Function() onDelete;
  final TabController tabController;
  final IconData? icon;

  const EntriesTabLabel({required this.index, required this.label, required this.onDelete, required this.tabController, this.icon, super.key});

  @override
  State createState() => _State();
}

class _State extends State<EntriesTabLabel> {
  late final AppModel model;

  @override
  void initState() {
    super.initState();
    model = context.read<AppModel>();
    widget.tabController.addListener(onTabChanged);
  }

  @override
  void dispose() {
    widget.tabController.removeListener(onTabChanged);
    super.dispose();
  }

  void onTabChanged() {
    model.selectedTabIndex.value = widget.tabController.index;
    setState(() {
      // pass
    });
  }

  @override
  build(BuildContext context) {
    final isSelected = widget.tabController.index == widget.index;
    final icon = widget.icon;
    return Tab(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Icon(icon, color: isSelected ? Colors.white : Colors.white54)
          ),
          Text(widget.label, style: isSelected ? const TextStyle(color: Colors.white, fontWeight: FontWeight.bold) : const TextStyle(color: Colors.white54)),
          IconButton(
              icon: const Icon(Icons.close, size: 16,),
              onPressed: widget.onDelete
          ),
        ],
      )
    );
  }
}