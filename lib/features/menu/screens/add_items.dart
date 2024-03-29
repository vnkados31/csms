// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:csm_system/common/widgets/custom_button.dart';
import 'package:csm_system/features/menu/services/menu_services.dart';
import 'package:flutter/material.dart';

class AddItemScreen extends StatefulWidget {
  final String day;
  final String dropdownValue;
  final VoidCallback initFunction;
  const AddItemScreen(
      {Key? key,
      required this.day,
      required this.dropdownValue,
      required this.initFunction})
      : super(key: key);

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final postController = TextEditingController();
  bool loading = false;
  final MenuServices menuServices = MenuServices();

  void addMenuItem() {
    menuServices.addMenuItem(
        context: context,
        name: postController.text,
        day: widget.day,
        type: widget.dropdownValue);
  }

  @override
  void dispose() {
    super.dispose();
    postController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Item (${widget.dropdownValue})'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            TextFormField(
              maxLines: 4,
              controller: postController,
              decoration: const InputDecoration(
                  hintText: 'Add Menu Item', border: OutlineInputBorder()),
            ),
            const SizedBox(
              height: 30,
            ),
            CustomButton(
                text: 'Add',
                onTap: () {
                  setState(() {
                    loading = true;
                  });

                  addMenuItem();
                
                  loading = false;

                  widget.initFunction();
                })
          ],
        ),
      ),
    );
  }
}
