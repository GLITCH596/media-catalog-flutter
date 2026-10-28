import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_catalog_learning/bloc/games_bloc.dart';

class SearchAppBar extends StatefulWidget implements PreferredSizeWidget{
  const SearchAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  State<SearchAppBar> createState() => _SearchAppBarState();
}

class _SearchAppBarState extends State<SearchAppBar> {
  bool _searching = false;
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: _searching ? TextField(
        controller: _controller,
        autofocus: true,
        textInputAction: TextInputAction.search,
        decoration: const InputDecoration(
          hintText: 'Find a game',
          border: InputBorder.none,
        ),
        onSubmitted: (query) {
          context.read<GamesBloc>().add(GamesSearchSubmitted(query));
          setState(() => _searching = false);
        },
      ) : const Text('Popular games'),
      actions: [
        IconButton(
            onPressed: () {
              setState(() {
                _searching = !_searching;
                if (!_searching) _controller.clear();
              });
            },
            icon: Icon(_searching ? Icons.close : Icons.search),
        )
      ],
    );
  }
}
