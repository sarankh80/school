import 'package:com.gogospider.booking/component/cached_image_widget.dart';
import 'package:com.gogospider.booking/component/price_widget.dart';
import 'package:com.gogospider.booking/model/service_data_model.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class ImageOptionComponent extends StatefulWidget {
  final ServiceData? serviceDetail;
  final bool isFavouriteService;

  ImageOptionComponent({this.serviceDetail, this.isFavouriteService = false});

  @override
  State<ImageOptionComponent> createState() => _ImageOptionComponentState();
}

class _ImageOptionComponentState extends State<ImageOptionComponent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            child: CachedImageWidget(
              url: widget.isFavouriteService
                  ? widget.serviceDetail!.serviceAttachments
                          .validate()
                          .isNotEmpty
                      ? widget.serviceDetail!.serviceAttachments!.first
                          .validate()
                      : ''
                  : widget.serviceDetail!.attachments.validate().isNotEmpty
                      ? widget.serviceDetail!.attachments!.first.validate()
                      : '',
              fit: BoxFit.cover,
              height: 200,
              width: context.width(),
              circle: false,
            )
                .cornerRadiusWithClipRRectOnly(
                    topRight: defaultRadius.toInt(),
                    topLeft: defaultRadius.toInt())
                .paddingOnly(left: 15, right: 15, bottom: 15, top: 15),
          ),
          Container(
            padding: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
            alignment: Alignment.centerLeft,
            child: Text(widget.serviceDetail!.name.validate(),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          Container(
            padding: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
            alignment: Alignment.centerLeft,
            child: PriceWidget(
              price: widget.serviceDetail!.price.validate(),
              isHourlyService: widget.serviceDetail!.isHourlyService,
              color: redColor,
              hourlyTextColor: Colors.red,
              size: 16,
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
            alignment: Alignment.centerLeft,
            child: Text(widget.serviceDetail!.description.validate(),
                maxLines: 2, style: TextStyle(fontSize: 14)),
          ),
        ],
      ),
    );
  }
}
