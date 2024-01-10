import 'package:chatter/features/presentation/about/pages/about/components/license_data.dart';
import 'package:chatter/features/presentation/about/pages/about/components/license_page.dart';
import 'package:flutter/material.dart';

class LicenseEntryTile extends StatelessWidget {
  final LicenseData licenseData;
  final int index;

  const LicenseEntryTile({
    super.key,
    required this.licenseData,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final String packageName = licenseData.packages[index];
    final List<int> bindings = licenseData.packageLicenseBindings[packageName]!;

    return ListTile(
      title: Text(packageName, style: const TextStyle(fontSize: 14.0)),
      dense: true,
      visualDensity: const VisualDensity(vertical: -4),
      onTap: () async => await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => LicenseDetailsPage(
          packageName: packageName,
          packageLicenses: bindings
              .map((int i) => licenseData.licenses[i])
              .toList(growable: false),
        ),
      )),
      subtitle: Text(
        MaterialLocalizations.of(context)
            .licensesPackageDetailText(bindings.length),
      ),
      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16.0),
    );
  }
}
