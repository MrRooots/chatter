part of 'contact_search_bloc.dart';

abstract class ContactSearchState extends Equatable {
  const ContactSearchState();
}

class ContactSearchInitial extends ContactSearchState {
  @override
  List<Object> get props => [];
}
