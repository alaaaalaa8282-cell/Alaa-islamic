import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/database/database_service.dart';
import '../../../core/util/bloc/database/database_bloc.dart';
import '../../../core/util/bloc/quran/quran_bloc.dart';
import '../../../core/util/model/quran.dart';

Future<void> toggleQuranFavorite(BuildContext context, Quran quran) async {
  final db = BlocProvider.of<DatabaseBloc>(context).db;
  if (db == null) {
    return;
  }

  final favoriteAyatIds =
      await DatabaseService().toggleQuranFavorite(db, quran);
  BlocProvider.of<QuranBloc>(context).add(
    SyncQuranFavorites(favoriteAyatIds),
  );
}
