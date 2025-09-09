import 'package:flutter/material.dart';
import 'package:soryu/l10n/app_localizations.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../domain/entities/user.dart';
import '../../common/core/utils/color_utils.dart';
import '../../common/core/utils/user_utils.dart';

class SearchWidget extends HookConsumerWidget implements PreferredSizeWidget {
  final TextEditingController searchController;
  final Future<List<User>> Function(String) onSearchChanged;

  const SearchWidget({
    super.key,
    required this.searchController,
    required this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        AppBar(
          backgroundColor: ColorUtils.white,
          title: Text(AppLocalizations.of(context)!.search),
        ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: TypeAheadField<User>(
              suggestionsCallback: (String query) async {
                if (query.isNotEmpty) {
                  return await onSearchChanged(query);
                }
                return [];
              },
              itemBuilder: (BuildContext context, User suggestion) {
                return ListTile(
                  title: Text(UserUtils.getNameOrUsername(suggestion)),
                );
              },
              onSelected: (User suggestion) {
                UserUtils.goToProfile(suggestion);
              },
              emptyBuilder: (BuildContext context) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(AppLocalizations.of(context)!.no_data),
                );
              },
              builder: (context, controller, focusNode) {
                return TextField(
                  controller: controller,
                  focusNode: focusNode,
                  decoration: InputDecoration(
                    hintText: '${AppLocalizations.of(context)!.search}...',
                    border: const OutlineInputBorder(),
                    suffixIconColor: ColorUtils.main,
                    suffixIcon: const Icon(Icons.search),
                  ),
                );
              },
            )),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
