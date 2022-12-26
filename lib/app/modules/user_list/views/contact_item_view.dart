import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../models/user_model.dart';

class ContactItem extends StatelessWidget {
  User contact;
  ContactItem(this.contact, {Key? key, this.onTap}) : super(key: key);
  Function()? onTap;


  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
      ),
      elevation: 1,
      child: InkWell(
        borderRadius: const BorderRadius.all(
          Radius.circular(5),
        ),
        onTap: () {
        },
        child: ClipRRect(
          borderRadius: const BorderRadius.all(
            Radius.circular(5),
          ),
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                const SizedBox(width: 25,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Text(contact.name??"Unknown", style: TextStyle(fontSize: 16,  overflow: TextOverflow.ellipsis), maxLines: 1,),
                      ),
                      SizedBox(height: 7,),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}