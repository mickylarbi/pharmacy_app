import 'package:flutter/material.dart';
import 'package:pharmacy_app/models/drug.dart';
import 'package:pharmacy_app/utils/constants.dart';

class DrugDetails extends StatefulWidget {
  final Drug? drug;
  const DrugDetails({super.key, this.drug});

  @override
  State<DrugDetails> createState() => _DrugDetailsState();
}

class _DrugDetailsState extends State<DrugDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            expandedHeight: 200,
            flexibleSpace: FlexibleSpaceBar(background: FlutterLogo()),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Brand name',
                    style: labelTextStyle,
                  ),
                  Text(widget.drug!.brandName!),
                  const SizedBox(height: 20),
                  Text(
                    'General name',
                    style: labelTextStyle,
                  ),
                  Text(widget.drug!.genericName!),
                  const SizedBox(height: 20),
                  Text(
                    'Class',
                    style: labelTextStyle,
                  ),
                  Text(widget.drug!.group!),
                  const SizedBox(height: 20),
                  Text(
                    'Price',
                    style: labelTextStyle,
                  ),
                  Text('GH¢ ${widget.drug!.price!.toStringAsFixed(2)}'),
                  const SizedBox(height: 20),
                  Text(
                    'Other details',
                    style: labelTextStyle,
                  ),
                  Text(widget.drug!.otherDetails!),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}


// ListView(
//         padding: const EdgeInsets.all(20),
//         children: [
//           const FlutterLogo(size: 200),
//           const SizedBox(height: 50),
//           Text(
//             'Brand name',
//             style: labelTextStyle,
//           ),
//           Text(widget.drug!.brandName!),
//           const SizedBox(height: 20),
//           Text(
//             'General name',
//             style: labelTextStyle,
//           ),
//           Text(widget.drug!.genericName!),
//           const SizedBox(height: 20),
//           Text(
//             'Class',
//             style: labelTextStyle,
//           ),
//           Text(widget.drug!.group!),
//           const SizedBox(height: 20),
//           Text(
//             'Price',
//             style: labelTextStyle,
//           ),
//           Text('GH¢ ${widget.drug!.price!.toStringAsFixed(2)}'),
//           const SizedBox(height: 20),
//           Text(
//             'Other details',
//             style: labelTextStyle,
//           ),
//           Text(widget.drug!.otherDetails!),
//           const SizedBox(height: 20),
//         ],
//       ),
   