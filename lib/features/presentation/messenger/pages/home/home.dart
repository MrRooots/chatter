import 'package:chatter/core/themes/palette.dart';
import 'package:chatter/features/domain/messenger/entities/dialog_entity.dart';
import 'package:chatter/features/domain/messenger/entities/message_entity.dart';
import 'package:chatter/features/presentation/messenger/pages/home/components/dialog_card.dart';
import 'package:chatter/features/presentation/messenger/pages/search_users/search_users.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

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
      } else {
        if (d == ScrollDirection.forward && !_isVisible) {
          setState(() => _isVisible = true);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<DialogEntity> dialogs = [
      DialogEntity(id: '1', messages: [
        MessageEntity(
          to: 'to',
          senderId: 'senderId',
          senderInitials: 'senderInitials',
          body: 'body',
          createdTimestamp: DateTime.now().millisecondsSinceEpoch,
          isViewed: false,
        )
      ])
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('All chats'),
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: RefreshIndicator(
          color: Palette.lightGreenSalad,
          onRefresh: () async {
            await Future.delayed(const Duration(milliseconds: 500));
          },
          child: ListView.builder(
            controller: _listController,
            physics: const BouncingScrollPhysics(),
            itemCount: dialogs.length * 24,
            itemBuilder: (context, index) {
              return DialogCard(dialog: dialogs[index % dialogs.length]);
            },
          ),
        ),
      ),
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
