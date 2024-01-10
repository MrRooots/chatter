import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class LicenseDetailsPage extends StatelessWidget {
  final String packageName;
  final List<LicenseEntry> packageLicenses;

  const LicenseDetailsPage({
    super.key,
    required this.packageName,
    required this.packageLicenses,
  });

  @override
  Widget build(BuildContext context) {
    final List<Widget> licenses = [];

    for (final LicenseEntry license in packageLicenses) {
      for (final LicenseParagraph paragraph in license.paragraphs) {
        if (paragraph.indent == LicenseParagraph.centeredIndent) {
          licenses.add(Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Text(
              paragraph.text,
              style: const TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ));
          licenses.add(const Divider());
        } else {
          licenses.add(Padding(
            padding: EdgeInsetsDirectional.only(
              top: 8.0,
              start: 16.0 * paragraph.indent,
            ),
            child: Text(paragraph.text),
          ));
        }
      }
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
        automaticallyImplyLeading: false,
        leading: IconButton(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: ListView(
          children: [
            const SizedBox(height: 16.0),
            Text(
              packageName,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8.0),
            ...licenses,
          ],
        ),
      ),
    );
  }
}
