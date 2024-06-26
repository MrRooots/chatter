import 'package:chatter/core/themes/palette.dart';
import 'package:chatter/features/presentation/common/bloc/authentication/authentication_bloc.dart';
import 'package:chatter/features/presentation/messenger/bloc/dialogs_list_bloc/dialogs_list_bloc.dart';
import 'package:chatter/features/presentation/messenger/pages/home/components/dialog_card.dart';
import 'package:chatter/features/presentation/messenger/pages/home/components/dialog_load_fail.dart';
import 'package:chatter/features/presentation/messenger/pages/home/components/no_dialogs_placeholder.dart';
import 'package:chatter/features/presentation/messenger/pages/search_users/search_users.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/home';

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isVisible = true;
  final _listController = ScrollController();

  @override
  void initState() {
    super.initState();

    _listController.addListener(() {
      final ScrollDirection d = _listController.position.userScrollDirection;

      if (d == ScrollDirection.reverse && _isVisible) {
        setState(() => _isVisible = false);
      } else if (d == ScrollDirection.forward && !_isVisible) {
        setState(() => _isVisible = true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All chats'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onPressed: () => Navigator.of(context).pushNamed('/profile'),
            icon: const ImageIcon(
              AssetImage('assets/images/user.png'),
              size: 24.0,
            ),
          )
        ],
      ),
      body: RefreshIndicator(
          color: Palette.lightGreenSalad,
          onRefresh: () async {
            BlocProvider.of<DialogsListBloc>(context).add(DialogsListFetch(
                user:
                    BlocProvider.of<AuthenticationBloc>(context).currentUser));
          },
          child: BlocBuilder<DialogsListBloc, DialogsListState>(
            builder: (context, state) {
              if (state.isSuccess) {
                if (state.dialogs!.isEmpty) return const NoDialogsPlaceholder();

                return ListView.builder(
                  controller: _listController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: state.dialogs!.length,
                  itemBuilder: (context, index) {
                    return DialogCard(
                      dialog: state.dialogs![index],
                    );
                  },
                );
              } else if (state.isFailed) {
                return const DialogLoadingFailedPlaceholder();
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          )),
      floatingActionButton: AnimatedSlide(
        duration: const Duration(milliseconds: 250),
        offset: _isVisible ? Offset.zero : const Offset(0, 2),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 250),
          opacity: _isVisible ? 1 : 0,
          child: FloatingActionButton(
            onPressed: () =>
                Navigator.of(context).pushNamed(SearchUsersPage.routeName),
            tooltip: 'Write new message',
            child: const Icon(Icons.create_rounded, color: Palette.white),
          ),
        ),
      ),
    );
  }
}
