import 'package:dw_barbershop/app/core/ui/styles/colors_app.dart';
import 'package:dw_barbershop/app/core/ui/styles/icons_app.dart';
import 'package:dw_barbershop/app/core/ui/styles/images_app.dart';
import 'package:flutter/material.dart';

class AvatarWidget extends StatelessWidget {
  final bool hideUploadButton;
  const AvatarWidget({super.key, this.hideUploadButton = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 102,
      width: 102,
      child: Stack(
        children: [
          Container(
            height: 90,
            width: 90,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(ImagesApp.avatar),
              ),
            ),
          ),
          Positioned(
            bottom: 2,
            right: 2,
            child: Offstage(
              offstage: hideUploadButton,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: ColorsApp.brow, width: 4),
                  shape: BoxShape.circle
                ),
                child: const Icon(
                  IconsApp.addEmployee,
                  color: ColorsApp.brow,
                  size: 20,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
