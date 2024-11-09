import 'package:com.gogospider.booking/component/cached_image_widget.dart';
import 'package:com.gogospider.booking/model/service_data_model.dart';
import 'package:com.gogospider.booking/screens/gallery/gallery_component.dart';
import 'package:com.gogospider.booking/screens/gallery/gallery_screen.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class DetailHeadComponent extends StatefulWidget {
  final ServiceData? serviceDetail;

  const DetailHeadComponent({required this.serviceDetail, Key? key})
      : super(key: key);

  @override
  State<DetailHeadComponent> createState() => _DetailHeadComponentState();
}

class _DetailHeadComponentState extends State<DetailHeadComponent> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.width() + (context.width() * 0.05),
      width: context.width(),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          if (widget.serviceDetail!.attachments.validate().isNotEmpty)
            SizedBox(
              height: context.width() + (context.width() * 0.05),
              width: context.width(),
              child: CachedImageWidget(
                url: widget.serviceDetail!.attachments!.first,
                fit: BoxFit.fill,
                height: context.width() + (context.width() * 0.05),
              ),
            ),
          Positioned(
            top: context.statusBarHeight + 8,
            left: 10,
            child: Container(
              width: 30,
              height: 30,
              child: Icon(
                Icons.close,
                color: redColor,
                size: 18,
              ),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(color: redColor, width: 2),
              ),
            ).onTap(() {
              finish(context);
            }),
          ),
          Container(
            child: Positioned(
              bottom: 0,
              left: 16,
              right: 16,
              child: Column(
                children: [
                  Row(
                    children: [
                      Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        children: List.generate(
                          widget.serviceDetail!.attachments!.take(2).length,
                          (i) => Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: white, width: 2),
                                borderRadius: radius()),
                            child: GalleryComponent(
                                images: widget.serviceDetail!.attachments!,
                                index: i,
                                padding: 32,
                                height: 60,
                                width: 60),
                          ),
                        ),
                      ),
                      16.width,
                      if (widget.serviceDetail!.attachments!.length > 2)
                        Blur(
                          borderRadius: radius(),
                          padding: EdgeInsets.zero,
                          child: Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                              border: Border.all(color: white, width: 2),
                              borderRadius: radius(),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                                '+'
                                '${widget.serviceDetail!.attachments!.length - 2}',
                                style: boldTextStyle(color: white)),
                          ),
                        ).onTap(() {
                          GalleryScreen(
                            serviceName: widget.serviceDetail!.name.validate(),
                            attachments:
                                widget.serviceDetail!.attachments.validate(),
                          ).launch(context);
                        }),
                    ],
                  ),
                  16.height,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
