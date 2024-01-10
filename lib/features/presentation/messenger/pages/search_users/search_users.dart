import 'package:chatter/features/presentation/common/bloc/authentication/authentication_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchUsersPage extends StatelessWidget {
  static const String routeName = '/searchUsers';

  const SearchUsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppBarWithSearch(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: SearchUsersPageBody(),
      ),
    );
  }
}

class SearchUsersPageBody extends StatelessWidget {
  const SearchUsersPageBody({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('/users')
          .where('id',
              isNotEqualTo:
                  BlocProvider.of<AuthenticationBloc>(context).currentUser.id)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final data = snapshot.data!.docs[index].data();
              return ListTile(
                onTap: () {},
                title: Text(data['firstname'] + ' ' + data['lastname']),
                subtitle: Text(data['id']),
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
