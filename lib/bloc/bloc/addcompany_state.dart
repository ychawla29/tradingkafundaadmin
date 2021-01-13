part of 'addcompany_bloc.dart';

@immutable
abstract class AddcompanyState {}

class AddcompanyInitial extends AddcompanyState {}

class AddcompanyBusyState extends AddcompanyState {}

class AddcompanyLoadedState extends AddcompanyState {}
