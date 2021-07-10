part of 'viewcompany_bloc.dart';

abstract class ViewcompanyEvent extends Equatable {
  const ViewcompanyEvent();

  @override
  List<Object> get props => [];
}

class FetchViewCompanyEvent extends ViewcompanyEvent {}

