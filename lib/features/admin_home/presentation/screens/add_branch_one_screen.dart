import 'package:flutter/material.dart';
import 'package:gymbook/features/admin_home/data/models/branch_list_model.dart';
import 'package:gymbook/features/admin_home/presentation/widgets/add_branch_one_screen_body.dart';

class AddBranchOneScreen extends StatelessWidget {
  final BranchScreenArgs? args;

  const AddBranchOneScreen({super.key, this.args});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: AddBranchOneScreenBody(args: args));
  }
}
