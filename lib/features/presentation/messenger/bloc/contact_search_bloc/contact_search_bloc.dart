import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'contact_search_event.dart';
part 'contact_search_state.dart';

class ContactSearchBloc extends Bloc<ContactSearchEvent, ContactSearchState> {
  ContactSearchBloc() : super(ContactSearchInitial()) {
    on<ContactSearchEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
