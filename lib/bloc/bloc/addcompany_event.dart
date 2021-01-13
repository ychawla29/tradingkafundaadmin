part of 'addcompany_bloc.dart';

@immutable
abstract class AddcompanyEvent {}

class AddCompanyEvent extends AddcompanyEvent{

  final Company company;

  AddCompanyEvent(this.company);

}