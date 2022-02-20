// import 'package:clicandeats/models/order.dart';
//
// import 'package:flutter/material.dart';
//
// class OrderedProductCard extends StatelessWidget {
//   final OrderedMeal order;
//   OrderedProductCard({required this.order});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(0.0),
//       child: Container(
//        // padding: EdgeInsets.all(10),
//         decoration: BoxDecoration(
//          // borderRadius: BorderRadius.circular(10),
//           color: Colors.white,
//           boxShadow: [
//             BoxShadow(
//               blurRadius: 10,
//               color: Colors.grey[100]!,
//             )
//           ],
//         ),
//         child: Row(
//           children: [
//             Container(
//               width: MediaQuery.of(context).size.width / 4,
//               height: MediaQuery.of(context).size.width / 6,
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(6),
//
//                 child: Image.asset(order.img, fit: BoxFit.cover,),
//               ),
//             ),
//             SizedBox(
//               width: 20,
//             ),
//             Expanded(
//               child: Container(
//                 height: MediaQuery.of(context).size.width / 6,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   mainAxisSize: MainAxisSize.max,
//                   children: [
//                     Text(
//                       order.name,
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                       style: TextStyle(
//                         fontSize: 12,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.black,
//                       ),
//                     ),
//                     Row(
//                       children: [
//                         Text(
//                           "X${order.qtt} ",
//                           style: TextStyle(
//                             fontSize: 12,
//                             color: Colors.black,
//                           ),
//                         ),
//                         Text(
//                           "(${(order.price).toStringAsFixed(2)}€)",
//                           style: TextStyle(
//                             fontSize: 12,
//                             color: Colors.black,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
