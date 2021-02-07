part of 'editcompany_bloc.dart';

abstract class EditcompanyState extends Equatable {
  const EditcompanyState();

  @override
  List<Object> get props => [];
}

class EditcompanyInitial extends EditcompanyState {}

class EditcompanyLoaded extends EditcompanyState {
  final String companyName;
  final String companyShortName;

  EditcompanyLoaded({
    @required this.companyName,
    @required this.companyShortName,
  });
}

class EditcompanySaved extends EditcompanyState {}
