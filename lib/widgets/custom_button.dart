import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  // নতুন: ঐচ্ছিক রঙ প্যারামিটার যোগ করা হয়েছে
  final Color? color;

  const CustomButton({
    super.key, 
    required this.text, 
    required this.onPressed,
    this.color, // কনস্ট্রাক্টরে গ্রহণ করা হলো
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        // যদি 'color' দেওয়া থাকে, তবে সেটি ব্যবহার করা হবে, অন্যথায় ডিফল্ট রং
        backgroundColor: color ?? const Color(0xFFE67823),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onPressed: onPressed,
      child: Text(
        text, 
        style: const TextStyle(
          fontSize: 16,
          color: Colors.white, // বাটনের টেক্সটের রঙ সাদা নিশ্চিত করা হলো
        ),
      ),
    );
  }
}