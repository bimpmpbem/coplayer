import 'package:flutter/material.dart';

// TODO move to proper spec/theme/theme extension
abstract class YoutubeTheme {
  static const Color cardBackground = Color.fromARGB(255, 238, 238, 238);

  static const Color messageAuthorIsOwnerBackground =
      Color.fromARGB(255, 255, 214, 0);
  static const Color authorIsModeratorColor = Color.fromARGB(255, 95, 132, 241);

  static const Color membershipHeaderBackground = Color.fromARGB(255, 10, 128, 67);
  static const Color membershipBodyBackground = Color.fromARGB(255, 15, 157, 88);

  static const Color primaryTextColor = Color.fromARGB(255, 15, 15, 15);
  static const Color invertedTextColor = Color.fromARGB(255, 255, 255, 255);
  static const Color secondaryTextColor = Color.fromARGB(255, 96, 96, 96);

  static final timestampStyle = TextStyle(
    fontSize: 11,
    color: primaryTextColor.withOpacity(0.4),
  );

  static final messageAuthorStyle = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: primaryTextColor.withOpacity(0.6),
  );
  static const paidMessageAuthorStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: Color.fromRGBO(0, 0, 0, 0.54),
    overflow: TextOverflow.ellipsis,
  );
  static const membershipAuthorBigStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: Colors.white,
    overflow: TextOverflow.ellipsis,
  );
  static const membershipAuthorSmallStyle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: Colors.white,
    overflow: TextOverflow.ellipsis,
  );

  static const purchaseAmountStyle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: Colors.black,
  );

  static const membershipHeaderStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );

  static const membershipSubtextBigStyle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: Color.fromRGBO(255, 255, 255, 0.7),
  );
  static const membershipSubtextSmallStyle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: Color.fromRGBO(255, 255, 255, 0.7),
  );

  static const chatUrlStyle = TextStyle(
    fontSize: 13,
    color: primaryTextColor,
    decoration: TextDecoration.underline,
  );

  static const messageStyle = TextStyle(
    fontSize: 13,
    color: primaryTextColor,
  );
  static const paidMessageStyle = TextStyle(
    fontSize: 15,
    color: Colors.black,
  );
  static const membershipMessageStyle = TextStyle(
    fontSize: 15,
    color: Colors.white,
  );

  static const viewerEngagementStyle = TextStyle(
    fontSize: 12,
    color: primaryTextColor,
  );

  static final cardShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(4),
  );
}
