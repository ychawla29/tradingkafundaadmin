part of 'viewcompany_bloc.dart';

abstract class ViewcompanyState extends Equatable {
  const ViewcompanyState();

  @override
  List<Object> get props => [];
}

class ViewcompanyInitial extends ViewcompanyState {}

class ViewcompanyLoaded extends ViewcompanyState {
  List<Company> companiesList;

  ViewcompanyLoaded([this.companiesList]);

  @override
  List<Object> get props => [companiesList];
}
