import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_fix/src/features/my%20wallet/bank%20card/add%20payment%20method/credit%20card%20scanner/creditcardscanner_screen.dart';

class AddPaymentMethodScreen extends StatefulWidget {
  @override
  _AddPaymentMethodScreenState createState() => _AddPaymentMethodScreenState();
}

class _AddPaymentMethodScreenState extends State<AddPaymentMethodScreen> {
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  final TextEditingController _postcodeController = TextEditingController();

  bool _isButtonEnabled = false;

  void _updateButtonState() {
    setState(() {
      _isButtonEnabled = _cardNumberController.text.isNotEmpty &&
          _expiryController.text.length ==
              5 && // Ensure expiry is in MM/YY format
          _cvvController.text.isNotEmpty &&
          _postcodeController.text.isNotEmpty;
    });
  }

  void _formatExpiryDate(String value) {
    String formatted = value.replaceAll("/", "");
    if (formatted.length > 4) {
      formatted = formatted.substring(0, 4);
    }
    if (formatted.length > 2) {
      formatted = formatted.substring(0, 2) + '/' + formatted.substring(2);
    }
    _expiryController.value = TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  @override
  void initState() {
    super.initState();
    _cardNumberController.addListener(_updateButtonState);
    _expiryController.addListener(_updateButtonState);
    _cvvController.addListener(_updateButtonState);
    _postcodeController.addListener(_updateButtonState);
  }

  @override
  void dispose() {
    _cardNumberController.removeListener(_updateButtonState);
    _expiryController.removeListener(_updateButtonState);
    _cvvController.removeListener(_updateButtonState);
    _postcodeController.removeListener(_updateButtonState);
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _postcodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Credit or Debit Card'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.blue,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 40.0),
                child: Icon(
                  Icons.credit_card,
                  size: 80,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _cardNumberController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      labelText: 'Enter card number',
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CreditCardScannerScreen(),
                            ),
                          );
                        },
                        icon: Icon(Icons.qr_code_scanner),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _expiryController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(4),
                          ],
                          decoration: InputDecoration(
                            labelText: 'Month/Year',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: _formatExpiryDate,
                        ),
                      ),
                      SizedBox(width: 16.0),
                      Expanded(
                        child: TextField(
                          controller: _cvvController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: InputDecoration(
                            labelText: 'CVV',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      SizedBox(width: 16.0),
                      Expanded(
                        child: TextField(
                          controller: _postcodeController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: InputDecoration(
                            labelText: 'Post code',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 32.0),
                  Center(
                    child: ElevatedButton(
                      onPressed: _isButtonEnabled ? () {} : null,
                      child: Text('Save'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        foregroundColor: Colors.white,
                        backgroundColor:
                            _isButtonEnabled ? Colors.blue : Colors.grey,
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Image.asset('assets/img/visa.png', height: 60),
                      Image.asset('assets/img/american_express.png',
                          height: 60),
                      Image.asset('assets/img/mastercard.png', height: 60),
                      Image.asset('assets/img/discover.png', height: 60),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
