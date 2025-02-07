import 'dart:convert';
import 'dart:core';
import 'package:flutter/gestures.dart';
import 'package:http/http.dart' as http;
import 'package:DartPay/main%20pages/home_screens/request_page/request.dart';
import 'package:DartPay/models/card_model.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:credit_card_scanner/credit_card_scanner.dart';
import 'package:credit_card_scanner/models/card_scan_options.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '../../../constants.dart';
import '../../../models/button_model/request_button.dart';
import 'transfer_payment.dart';

class SendMoney extends StatefulWidget {
  const SendMoney({Key? key}) : super(key: key);

  @override
  _SendMoneyState createState() => _SendMoneyState();
}

class _SendMoneyState extends State<SendMoney> {
  final c = TextEditingController();
  final _controller = MaskedTextController(mask: '0000 0000 0000 0000');
  CardDetails? _cardDetails;
  CardScanOptions scanOptions = const CardScanOptions(
    scanCardHolderName: false,
    scanExpiryDate: false,
    validCardsToScanBeforeFinishingScan: 5,
    possibleCardHolderNamePositions: [
      CardHolderNameScanPosition.aboveCardNumber,
    ],
  );
  Future<void> scanCard() async {
    var cardDetails = await CardScanner.scanCard(scanOptions: scanOptions);
    if (!mounted) return;
    setState(() {
      _cardDetails = cardDetails!;
    });
  }

  var _textController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    _textController.dispose();
    super.dispose();
  }

  var amount;

  @override
  void initState() {
    _textController.addListener(() {
      setState(() {
        amount = int.parse(_textController.text);
      });
    });
    super.initState();
  }

  var url = Uri.parse('https://cbu.uz/oz/arkhiv-kursov-valyut/json/');
  var showedCurrency;
  fetch() async {
    var response = await http.get(url);
    var jsData = jsonDecode(response.body);
    var rate = jsData[0]['Rate'];
    var sumOfCurrency = double.parse(rate);
    var convertedAmount = (sumOfCurrency * amount);
    setState(() {
      showedCurrency = convertedAmount;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                alignment: AlignmentDirectional.topCenter,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/startPage');
                    },
                    child: Container(
                      height: screenHeight * 0.85,
                      width: screenWidth,
                      child: Image.asset(
                        'assets/images/cardPicture5.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  IconButton(
                      padding:
                      EdgeInsets.only(top: 25, right: screenWidth * 0.88),
                      onPressed: (){
                    Navigator.pushNamed(context, '/startPage');
                  }, icon: SvgPicture.asset('assets/svg/vector_left.svg')),
                  const Padding(
                    padding: EdgeInsets.only(top: 25),
                    child: Text('Перевод',
                        style: kHeaderTextManualStyle),
                  ),
                  Container(
                    height: screenHeight * 0.88,
                    width: screenWidth,
                    margin: EdgeInsets.only(top: screenHeight * 0.12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(15),
                        topLeft: Radius.circular(15),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RequestButton(
                              colour: orangeColor,
                              data: const Text(
                                'Перевод',
                                style: kSendTextSendMoneyPage,
                              ),
                              onPress: () {},
                            ),
                            const SizedBox(width: 15),
                            RequestButton(
                              colour: Colors.white,
                              data: const Text('Запрос',
                                  style: kRequestTextSendMoneyPage),
                              onPress: () {
                                Navigator.pushReplacement(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation1, animation2) => RequestPage(),
                                    transitionDuration: Duration.zero,
                                    reverseTransitionDuration: Duration.zero,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 15),
                          child: Text(
                            'С карты',
                            style: kInputCardNumberStyle,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Container(
                          height: 75,
                          child: ListView.builder(
                              padding: EdgeInsets.only(right: 15),
                              scrollDirection: Axis.horizontal,
                              itemCount: cardList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  margin: EdgeInsets.only(left: 15),
                                  width: 280,
                                  decoration: BoxDecoration(
                                      color: orangeColor,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Stack(
                                    children: [
                                      SvgPicture.asset(
                                          'assets/svg/cardPicture1.svg'),
                                      Positioned(
                                        child: Text(
                                          cardList[index].cardName,
                                          style: kSendMoneyCardNumStyle,
                                        ),
                                        top: 12,
                                        right: 130,
                                        left: 20,
                                        bottom: 45,
                                      ),
                                      Positioned(
                                        child: Text(
                                          cardList[index].cardNumber,
                                          style: kSendMoneyCardNumStyle,
                                        ),
                                        top: 43,
                                        right: 111,
                                        left: 20,
                                        bottom: 12,
                                      ),
                                      Positioned(
                                        child: Image.asset(
                                            'assets/images/logo_uzcard_512.png'),
                                        top: 19,
                                        right: 21,
                                        left: 320,
                                        bottom: 25,
                                      ),
                                    ],
                                  ),
                                );
                              }),
                        ),
                        const SizedBox(height: 15),
                        const Padding(
                          padding: EdgeInsets.only(left: 15),
                          child: Text(
                            'На карту',
                            style: kInputCardNumberStyle,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(left: 15),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Color(0xFFDADADA))
                              ),
                              width: 250,
                              height: 50,
                              child: TextField(
                                style: kInputTextStyleTextField,
                                cursorColor: greyColor,
                                cursorHeight: 20,
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.all(15),
                                  enabledBorder:InputBorder.none,
                                  focusedBorder: InputBorder.none
                                ),
                                keyboardType: TextInputType.number,
                                controller: _controller,
                              ),
                            ),
                            SizedBox(width: 10),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () async {
                                    scanCard();
                                  },
                                  icon: SvgPicture.asset(
                                      'assets/svg/scan_svg.svg'),
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: SvgPicture.asset(
                                      'assets/svg/user_plus.svg'),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Container(
                          margin: const EdgeInsets.only(left: 15, right: 15),
                          height: 200,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 17,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('К отправке'),
                                  SizedBox(
                                    width: 270,
                                    child: TextField(
                                      style: TextStyle(
                                        fontSize: 20
                                      ),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.all(20)
                                      ),
                                      keyboardType: TextInputType.number,
                                      controller: _textController,
                                    ),
                                  ),
                                ],
                              ),
                              Divider(),
                              Container(
                                margin: EdgeInsets.only(left: 10, right: 10),
                                height: 43,
                                width: MediaQuery.of(context).size.width,
                                child:
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('К получению'),
                                    showedCurrency == null
                                        ? Text('')
                                        : Text(
                                      "$showedCurrency",
                                      style: TextStyle(fontSize: 25),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                children: [
                                  ElevatedButton(onPressed: (){
                                    fetch();
                                  }, child: Text('click'))
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),
                        Container(
                          margin: const EdgeInsets.only(
                              left: 15, right: 15, bottom: 23),
                          height: 50,
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)
                              ),
                              primary: orangeColor,
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, '/transferPayment');
                            },
                            child: const Text(
                              'Продолжить',
                              style: kManualStyle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// child: Container(
//   height: screenHeight * 0.85,
//   width: screenWidth,
//   margin: EdgeInsets.only(top: screenHeight * 0.12),
//   decoration: BoxDecoration(
//     color: Theme.of(context).primaryColor,
//     borderRadius: const BorderRadius.only(
//       topRight: Radius.circular(15),
//       topLeft: Radius.circular(15),
//     ),
//   ),
//   child: Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       const SizedBox(height: 12),
//       Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           RequestButton(
//             colour: orangeColor,
//             data: const Text(
//               'Перевод',
//               style: kSendText,
//             ),
//             onPress: () {},
//           ),
//           const SizedBox(width: 15),
//           RequestButton(
//             colour: Colors.white,
//             data: const Text('Запрос',
//                 style: TextStyle(
//                     color: orangeColor,
//                     fontFamily: 'Gilroy-Regular',
//                     fontSize: 14,
//                     letterSpacing: 1,
//                     fontWeight: FontWeight.w500)),
//             onPress: () {
//               Navigator.pushNamed(context, '/requestPage');
//             },
//           ),
//         ],
//       ),
//       const SizedBox(
//         height: 20,
//       ),
//       const Padding(
//         padding: EdgeInsets.only(left: 15),
//         child: Text(
//           'С карты',
//           style: kInputCardNumberStyle,
//         ),
//       ),
//       const SizedBox(height: 15),
//       Container(
//         height: 75,
//         child: ListView.builder(
//             scrollDirection: Axis.horizontal,
//             itemCount: cardList.length,
//             itemBuilder: (BuildContext context, int index) {
//               return Container(
//                 margin: EdgeInsets.only(left: 15),
//                 width: 280,
//                 decoration: BoxDecoration(
//                     color: orangeColor,
//                     borderRadius:
//                         BorderRadius.circular(10)),
//                 child: Stack(
//                   children: [
//                     SvgPicture.asset(
//                         'assets/svg/cardPicture1.svg'),
//                     Positioned(
//                       child: Text(
//                         cardList[index].cardName,
//                         style: kSendMoneyCardNumStyle,
//                       ),
//                       top: 12,
//                       right: 130,
//                       left: 20,
//                       bottom: 45,
//                     ),
//                     Positioned(
//                       child: Text(
//                         cardList[index].cardNumber,
//                         style: kSendMoneyCardNumStyle,
//                       ),
//                       top: 43,
//                       right: 111,
//                       left: 20,
//                       bottom: 12,
//                     ),
//                     Positioned(
//                       child: Image.asset(
//                           'assets/images/logo_uzcard_512.png'),
//                       top: 19,
//                       right: 21,
//                       left: 320,
//                       bottom: 25,
//                     ),
//                   ],
//                 ),
//               );
//             }),
//       ),
//       const SizedBox(height: 15),
//       const Padding(
//         padding: EdgeInsets.only(left: 15),
//         child: Text(
//           'На карту',
//           style: kInputCardNumberStyle,
//         ),
//       ),
//       const SizedBox(height: 10),
//       Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             margin: const EdgeInsets.only(left: 10),
//             width: 250,
//             height: 50,
//             child: TextField(
//               cursorColor: greyColor,
//               decoration: const InputDecoration(
//                 enabledBorder: OutlineInputBorder(
//                   borderSide: BorderSide(color: greyColor),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderSide: BorderSide(color: greyColor),
//                 ),
//               ),
//               keyboardType: TextInputType.number,
//               controller: _controller,
//             ),
//           ),
//           SizedBox(width: 10),
//           Row(
//             children: [
//               IconButton(
//                 onPressed: () async {
//                   scanCard();
//                 },
//                 icon: SvgPicture.asset(
//                     'assets/svg/scan_svg.svg'),
//               ),
//               IconButton(
//                 onPressed: () {},
//                 icon: SvgPicture.asset(
//                     'assets/svg/user_plus.svg'),
//               ),
//             ],
//           ),
//         ],
//       ),
//       const SizedBox(height: 20),
//       Container(
//         margin: const EdgeInsets.only(left: 15, right: 15),
//         height: 160,
//         width: double.infinity,
//         decoration: BoxDecoration(
//             color: Colors.greenAccent,
//             borderRadius: BorderRadius.circular(10)),
//       ),
//       const SizedBox(height: 30),
//       Container(
//         margin: const EdgeInsets.only(
//             left: 15, right: 15, bottom: 23),
//         height: 50,
//         width: double.infinity,
//         child: ElevatedButton(
//           style: ElevatedButton.styleFrom(
//             primary: orangeColor,
//           ),
//           onPressed: () {
//             Navigator.pushNamed(
//                 context, '/transferPayment');
//           },
//           child: const Text(
//             'Продолжить',
//             style: kManualStyle,
//           ),
//         ),
//       ),
//     ],
//   ),
// ),
