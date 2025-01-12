import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:phone_auth_handler_demo/screens/home_screen.dart';
import 'package:phone_auth_handler_demo/utils/helpers.dart';
import 'package:phone_auth_handler_demo/widgets/custom_loader.dart';
import 'package:phone_auth_handler_demo/widgets/pin_input_field.dart';

class VerifyPhoneNumberScreen extends StatefulWidget {
  static const id = 'VerifyPhoneNumberScreen';

  final String phoneNumber;

  const VerifyPhoneNumberScreen({
    super.key,
    required this.phoneNumber,
  });

  @override
  State<VerifyPhoneNumberScreen> createState() =>
      _VerifyPhoneNumberScreenState();
}

class _VerifyPhoneNumberScreenState extends State<VerifyPhoneNumberScreen>
    with WidgetsBindingObserver {
  bool isKeyboardVisible = false;

  late final ScrollController scrollController;

  @override
  void initState() {
    scrollController = ScrollController();
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    scrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final bottomViewInsets = WidgetsBinding
        .instance.platformDispatcher.views.first.viewInsets.bottom;
    isKeyboardVisible = bottomViewInsets > 0;
  }

  Future<void> _scrollToBottomOnKeyboardOpen() async {
    while (!isKeyboardVisible) {
      await Future.delayed(const Duration(milliseconds: 50));
    }

    await Future.delayed(const Duration(milliseconds: 250));

    await scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FirebasePhoneAuthHandler(
        phoneNumber: widget.phoneNumber,
        signOutOnSuccessfulVerification: false,
        sendOtpOnInitialize: true,
        linkWithExistingUser: false,
        autoRetrievalTimeOutDuration: const Duration(seconds: 60),
        otpExpirationDuration: const Duration(seconds: 60),
        onCodeSent: () {
          log(VerifyPhoneNumberScreen.id, msg: 'OTP sent!');
        },
        onLoginSuccess: (userCredential, autoVerified) async {
          log(
            VerifyPhoneNumberScreen.id,
            msg: autoVerified
                ? 'OTP was fetched automatically!'
                : 'OTP was verified manually!',
          );

          showSnackBar('Phone number verified successfully!');

          log(
            VerifyPhoneNumberScreen.id,
            msg: 'Login Success UID: ${userCredential.user?.uid}',
          );

          Navigator.pushNamedAndRemoveUntil(
            context,
            HomeScreen.id,
            (route) => false,
          );
        },
        onLoginFailed: (authException, stackTrace) {
          log(
            VerifyPhoneNumberScreen.id,
            msg: authException.message,
            error: authException,
            stackTrace: stackTrace,
          );

          switch (authException.code) {
            case 'invalid-phone-number':
              return showSnackBar('Invalid phone number!');
            case 'invalid-verification-code':
              return showSnackBar('The entered OTP is invalid!');
            default:
              showSnackBar('Something went wrong!');
          }
        },
        onError: (error, stackTrace) {
          log(
            VerifyPhoneNumberScreen.id,
            error: error,
            stackTrace: stackTrace,
          );

          showSnackBar('An error occurred!');
        },
        builder: (context, controller) {
          return Scaffold(
            backgroundColor: Theme.of(context).colorScheme.onPrimary,
           
            body: controller.isSendingCode
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        CustomLoader(),
                        SizedBox(height: 50),
                        Text(
                          'Sending OTP',
                          style: TextStyle(fontSize: 25),
                        ),
                      ],
                    ),
                  )
                : SingleChildScrollView(
                    controller: scrollController,
                     physics: const ClampingScrollPhysics(),
                    child:Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                       'assets/otp_verification_image.png',
                         width: 170,
                          height: 170,
              ),
                       const SizedBox(height: 30),
                       
                        const Text(
                         "OTP Verification",
                        style: TextStyle(
                            fontSize: 22,
                           fontWeight: FontWeight.bold,
                              fontFamily: 'Roboto',
                            color: Colors.white,
                ),
              ),
                        const SizedBox(height: 20),
                        Text(
                "Enter the OTP sent to  ${widget.phoneNumber}",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white54,
                  fontFamily: 'Roboto',
                ),
              ),
                        if (controller.isListeningForOtpAutoRetrieve)
                          Column(
                            children: const [
                              CustomLoader(),
                              SizedBox(height: 30),
                               Text("Listening to OTP",
                               style:TextStyle(
                                fontSize: 20,
                                fontFamily: "Roboto",
                                color:Colors.white,
                               ))
                            ],
                          ),
                        
                        const SizedBox(height: 30),

                        PinInputField(
                          length: 6,
                          onFocusChange: (hasFocus) async {
                            if (hasFocus) await _scrollToBottomOnKeyboardOpen();
                          },
                          onSubmit: (enteredOtp) async {
                            final verified =
                                await controller.verifyOtp(enteredOtp);
                            if (verified) {
                              // number verify success
                            } else {
                              // phone verification failed
                            }
                          },
                        ),
                        const SizedBox(height:40 ),
                        RichText(
                    text: TextSpan(
                      text: "Didn’t you receive the OTP? ",
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'Roboto',
                        color: Colors.white,
                      ),
                      children: [
                        TextSpan(
                          text: "Resend OTP",
                          style: TextStyle(color: Colors.blue, fontSize: 16, fontWeight: FontWeight.bold),
                          recognizer: TapGestureRecognizer()..onTap = () async {
                            if (controller.isOtpExpired) {
                              log(VerifyPhoneNumberScreen.id, msg: 'Resend OTP');
                              await controller.sendOTP();
                            } else {
                              showSnackBar('Please wait before resending the OTP.');
                            }
                          },
                        ),
                        TextSpan(
                         text: controller.otpExpirationTimeLeft.inSeconds > 0
                        ? " (${controller.otpExpirationTimeLeft.inSeconds}s)"
                              :null,
                         style: TextStyle(color: Colors.blue, fontSize: 16),
                       ),
                      ],
                    ),
                  )


                      ],
                    ),
                )
                  ),
          );
        },
      ),
    );
  }
}


