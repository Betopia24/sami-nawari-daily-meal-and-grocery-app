import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class QuantitySelector extends StatelessWidget {
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const QuantitySelector({
    super.key,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 88,
      height: 32,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: onDecrement,
            behavior: HitTestBehavior.opaque,
            child: const SizedBox(
              width: 24,
              height: 32,
              child: Center(
                child: Text(
                  '−',
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A1A),
                    height: 1.2,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '$quantity',
            style: const TextStyle(
              fontFamily: 'Outfit',
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1A1A),
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onIncrement,
            behavior: HitTestBehavior.opaque,
            child: const SizedBox(
              width: 24,
              height: 32,
              child: Center(
                child: Text(
                  '+',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A1A),
                    height: 1.2,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
