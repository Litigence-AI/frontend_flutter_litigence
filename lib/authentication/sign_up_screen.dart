// import 'package:flutter/material.dart';
// import '/src/authentication/thirdparty_auth.dart';
// import 'package:google_fonts/google_fonts.dart';
// import '/src/theme/font_weight.dart';
// import '/src/theme/color_code.dart';
//
// class SignUp extends StatefulWidget {
//   const SignUp({super.key});
//
//   @override
//   State<SignUp> createState() => _SignUpState();
// }
//
// class _SignUpState extends State<SignUp> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: colorCodeMap['Background'],
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.only(top: 20),
//           child: Column(
//             children: [
//               Text(
//                 "Hello there 👋",
//                 style: GoogleFonts.inter(
//                   fontSize: 20,
//                   fontWeight: fontWeightMap['Semi Bold'],
//                   color: colorCodeMap['Black'],
//                 ),
//               ),
//               Text(
//                 "Please enter you email & password to create an account",
//                 style: GoogleFonts.inter(
//                   fontSize: 14,
//                   fontWeight: fontWeightMap['Regular'],
//                   color: colorCodeMap['Gray'],
//                 ),
//               ),
//               const SizedBox(
//                 height: 20,
//               ),
//               Padding(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
//                 child: TextFormField(
//                   decoration: const InputDecoration(
//                     border: UnderlineInputBorder(),
//                     labelText: 'Email',
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
//                 child: TextFormField(
//                   decoration: const InputDecoration(
//                     border: UnderlineInputBorder(),
//                     labelText: 'Password',
//                   ),
//                 ),
//               ),
//               const ThirdpartyAuth()
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
