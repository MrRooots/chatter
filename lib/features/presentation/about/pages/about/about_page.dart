import 'package:chatter/core/themes/palette.dart';
import 'package:chatter/features/presentation/about/bloc/license_bloc/license_bloc.dart';
import 'package:chatter/features/presentation/about/pages/about/components/license_entry_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AboutPage extends StatelessWidget {
  static const String routeName = '/licences';

  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
        automaticallyImplyLeading: false,
        leading: IconButton(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
      ),
      body: BlocProvider<LicenseBloc>(
        create: (context) => LicenseBloc()..add(const LicenseLoad()),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              BlocBuilder<LicenseBloc, LicenseState>(
                builder: (context, state) {
                  if (state.isLoading) {
                    return const Expanded(
                      child: Center(
                        child: CircularProgressIndicator(strokeWidth: 3),
                      ),
                    );
                  } else if (state.isFailed) {
                    return Text(
                      'Ошибка при загрузке лицензий\n${state.message}',
                    );
                  } else {
                    return Expanded(
                      child: ListView.builder(
                        itemCount: state.licenses.packages.length + 1,
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            return const Column(
                              children: [
                                Text(
                                  'Made with',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 32.0,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(bottom: 16.0),
                                  child: FlutterLogo(
                                    size: 128.0,
                                    style: FlutterLogoStyle.stacked,
                                    textColor: Palette.black,
                                  ),
                                ),
                              ],
                            );
                          }

                          return LicenseEntryTile(
                            licenseData: state.licenses,
                            index: index - 1,
                          );
                        },
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
