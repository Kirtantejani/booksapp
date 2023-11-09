import 'package:flutter/cupertino.dart';

class ResuableText extends StatelessWidget {
  const ResuableText({super.key,required this.weight,required this.size,required this.color,required this.data});

  final String data;
  final Color color;
  final FontWeight weight;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Text(data,style: TextStyle(
    color: color,
    fontSize:size,
    fontWeight: weight
    ),
    );
  }
}
