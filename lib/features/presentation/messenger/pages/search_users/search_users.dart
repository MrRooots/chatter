import 'package:chatter/features/presentation/common/bloc/authentication/authentication_bloc.dart';
import 'package:chatter/features/presentation/messenger/bloc/dialogs_list_bloc/dialogs_list_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchUsersPage extends StatelessWidget {
  static const String routeName = '/searchUsers';

  const SearchUsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (final DragUpdateDetails details) {
        if (details.delta.dx > 6) Navigator.of(context).pop();
      },
      child: const Scaffold(
        appBar: AppBarWithSearch(),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: SearchUsersPageBody(),
        ),
      ),
    );
  }
}

class SearchUsersPageBody extends StatelessWidget {
  const SearchUsersPageBody({super.key});

  @override
  Widget build(BuildContext context) {
    final user = BlocProvider.of<AuthenticationBloc>(context).currentUser;
    final List<String> excludedIds = BlocProvider.of<DialogsListBloc>(context)
        .dialogs
        .map((e) => e.id)
        .toList()
      ..add(user.id);

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('/users')
          .where('id', whereNotIn: excludedIds)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final data = snapshot.data!.docs[index].data();
              return ListTile(
                onTap: () {
                  BlocProvider.of<DialogsListBloc>(context).add(
                    DialogsListAdd(user: user, dialogWith: data['id']),
                  );
                  Navigator.of(context).pop();
                },
                title: Text(data['firstname'] + ' ' + data['lastname']),
                subtitle: Text('@${data['username']}'),
              );
            },
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}

class AppBarWithSearch extends StatefulWidget implements PreferredSizeWidget {
  const AppBarWithSearch({super.key});

  @override
  State<AppBarWithSearch> createState() => _AppBarWithSearchState();

  @override
  Size get preferredSize => const Size(56.0, 56.0);
}

class _AppBarWithSearchState extends State<AppBarWithSearch> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  bool _isSearchActive = false;
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: _isSearchActive ? _searchField() : const Text('New massage to...'),
      automaticallyImplyLeading: false,
      titleSpacing: 0.0,
      leading: IconButton(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        onPressed: () => _isSearchActive
            ? setState(() => _isSearchActive = !_isSearchActive)
            : Navigator.of(context).pop(),
        icon: const Icon(Icons.arrow_back_ios_new_rounded),
      ),
      actions: [
        IconButton(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onPressed: () => setState(() {
                  _isSearchActive = !_isSearchActive;
                  _searchQuery = '';
                  _searchController.clear();
                  if (_isSearchActive) _searchFocusNode.requestFocus();
                }),
            icon: const Icon(Icons.search_rounded, size: 24.0))
      ],
    );
  }

  _searchField() {
    return TextFormField(
      controller: _searchController,
      focusNode: _searchFocusNode,
      decoration: const InputDecoration(hintText: 'Search'),
      onChanged: (value) => setState(() => _searchQuery = value),
    );
  }
}
