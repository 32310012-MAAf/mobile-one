import 'package:flutter/material.dart';

class ConverterScreen extends StatefulWidget {
  const ConverterScreen({super.key});

  @override
  State<ConverterScreen> createState() => _ConverterScreenState();
}

class _ConverterScreenState extends State<ConverterScreen> {
  final _controller = TextEditingController();

  final rates = {
    'USD': 1.0, 'EUR': 0.86, 'GBP': 0.76,
    'JPY': 156.36, 'CAD': 1.4, 'AUD': 1.53,
    'CNY': 7.08, 'LBP': 89661.21, 'BRL': 5.33,
  };
  String _fromCurrency = 'USD';
  String _toCurrency = 'EUR';
  double _result = 0.0;

  void _convert() {
    double? amount = double.tryParse(_controller.text);
    if (amount == null)
      return;
    setState(() { // converts currency -> USD then USD -> currency
      double inUSD = amount / rates[_fromCurrency]!;
      _result = inUSD * rates[_toCurrency]!;
    });
  }

  void _swap() {
    setState(() {
      String temp = _fromCurrency;
      _fromCurrency = _toCurrency;
      _toCurrency = temp;
      //  double inUSD = _result / rates[_fromCurrency]!;
      //  _result = inUSD * rates[_toCurrency]!;
      _result = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Currency Converter')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // input
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Amount in $_fromCurrency',
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 100),

            // selectors and swap button
            Row(
              children: [
                Expanded(// from currency
                  child: DropdownButton<String>(
                    value: _fromCurrency,
                    isExpanded: true,
                    items: rates.keys.map((c) {
                      return DropdownMenuItem(value: c, child: Text(c));
                    }).toList(),

                    onChanged: (val) => setState(() => _fromCurrency = val!),
                  ),
                ),
                IconButton(// swap button
                  onPressed: _swap,
                  icon: const Icon(Icons. swap_horizontal_circle_outlined),
                ),
                Expanded(// to currency
                  child: DropdownButton<String>(
                    value: _toCurrency,
                    isExpanded: true,
                    items: rates.keys.map((c) {
                      return DropdownMenuItem(value: c, child: Text(c));
                    }).toList(),

                    onChanged: (val) => setState(() => _toCurrency = val!),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            ElevatedButton(// currency conversion button
              onPressed: _convert,
              child: const Text('Convert currency'),
            ),
            const SizedBox(height: 30),

            // Result
            Text(
              '${_result.toStringAsFixed(2)} $_toCurrency',
              style: const TextStyle(fontSize: 30),
            ),
          ],
        ),
      ),
    );
  }
}