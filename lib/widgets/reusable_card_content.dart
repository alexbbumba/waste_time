import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ReusableCardContent extends StatelessWidget {
  const ReusableCardContent(
      {Key? key, required this.imageLink, required this.label})
      : super(key: key);
  final String imageLink;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 65,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              image: DecorationImage(
                  fit: BoxFit.contain,
                  image: AssetImage(
                    imageLink,
                  ))),
        ),
        const SizedBox(
          height: 5.0,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.4,
          child: Center(
            child: Text(
              label,
              softWrap: true,
              style: GoogleFonts.montserrat(
                textStyle: TextStyle(
                    fontSize: MediaQuery.of(context).size.height * 0.014,
                    color: Colors.black,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
