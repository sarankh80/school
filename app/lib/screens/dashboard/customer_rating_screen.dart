import 'package:com.gogospider.booking/component/back_widget.dart';
import 'package:com.gogospider.booking/component/background_component.dart';
import 'package:com.gogospider.booking/main.dart';
import 'package:com.gogospider.booking/model/dashboard_model.dart';
import 'package:com.gogospider.booking/screens/dashboard/component/customer_rating_widget.dart';
import 'package:com.gogospider.booking/utils/constant.dart';
import 'package:com.gogospider.booking/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class CustomerRatingScreen extends StatefulWidget {
  final List<DashboardCustomerReview> reviewData;

  CustomerRatingScreen({required this.reviewData});

  @override
  State<CustomerRatingScreen> createState() => _CustomerRatingScreenState();
}

class _CustomerRatingScreenState extends State<CustomerRatingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(language.lblReviewsOnServices,
          textColor: Colors.white,
          color: context.primaryColor,
          backWidget: BackWidget()),
      body: widget.reviewData.validate().isEmpty
          ? BackgroundComponent(
              text: language.lblNoRateYet, image: no_rating_bar)
          : AnimatedListView(
              padding: EdgeInsets.fromLTRB(8, 16, 8, 80),
              slideConfiguration: sliderConfigurationGlobal,
              itemCount: widget.reviewData.length,
              itemBuilder: (context, index) {
                return CustomerRatingWidget(
                  data: widget.reviewData[index],
                  onDelete: (data) {
                    widget.reviewData.remove(data);
                    setState(() {});
                  },
                );
              },
            ),
    );
  }
}
