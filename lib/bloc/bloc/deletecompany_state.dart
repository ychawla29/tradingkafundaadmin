part of 'deletecompany_bloc.dart';

abstract class DeletecompanyState extends Equatable {
  const DeletecompanyState();

  @override
  List<Object> get props => [];
}

class DeletecompanyInitial extends DeletecompanyState {}

class DeletecompanyLoaded extends DeletecompanyState {
  final String companyName;
  final String companyShortName;

  DeletecompanyLoaded(this.companyName, this.companyShortName);
}

class CompanyDeleted extends DeletecompanyState {}