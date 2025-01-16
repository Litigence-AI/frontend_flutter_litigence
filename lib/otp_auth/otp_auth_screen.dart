import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import '/utils/helpers.dart';

class OtpAuth extends StatefulWidget {

  const OtpAuth({super.key});

  @override
  State<OtpAuth> createState() => _OtpAuthState();
}

class _OtpAuthState extends State<OtpAuth> {
  String? phoneNumber;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: MediaQuery.of(context).size.width,
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: IntrinsicHeight(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
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
                  const SizedBox(height: 10),
                  const Text(
                    "We will send you one-time password to you mobile number",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white54,
                      fontFamily: 'Roboto',
                    ),
                  ),
                  const SizedBox(height: 20),
                  Form(
                    key: _formKey,
                    child: IntlPhoneField(
                      autofocus: true,
                      invalidNumberMessage: 'Invalid Phone Number!',
                      textAlignVertical: TextAlignVertical.center,
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                      onChanged: (phone) => phoneNumber = phone.completeNumber,
                      initialCountryCode: 'IN',
                      flagsButtonPadding: const EdgeInsets.only(right: 10),
                      showDropdownIcon: false,
                      decoration: InputDecoration(
                        labelText: 'Enter Mobile number',
                        labelStyle: TextStyle(color: Colors.white54),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white54),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white54),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).buttonTheme.colorScheme?.primaryContainer,
                      textStyle: TextStyle(
                        color: Theme.of(context).buttonTheme.colorScheme?.onPrimaryContainer, // Set the text color
                        fontSize: 18, // Set the text size
                        fontFamily: 'Roboto', // Set the font family
                        fontWeight: FontWeight.bold, // Set the font weight
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 15),
                      minimumSize: Size(double.infinity, 50),
                    ),
                    onPressed: () {
                      if (isNullOrBlank(phoneNumber) ||
                          !_formKey.currentState!.validate()) {
                        showSnackBar('Please enter a valid phone number!');
                      } else {
                        if (!mounted) return;

                        context.go(
                            '/verifyPhoneNumberScreen',
                          extra: phoneNumber
                        );

                      }
                    },
                    child: const Text(
                      'Get OTP',
                      style: TextStyle(
                        color: Colors.white, // Set the text color
                        fontSize: 18, // Set the text size
                        fontFamily: 'Roboto', // Set the font family
                        fontWeight: FontWeight.bold, // Set the font weight),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
