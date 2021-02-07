part of 'editcompany_bloc.dart';

abstract class EditcompanyEvent extends Equatable {
  const EditcompanyEvent();

  @override
  List<Object> get props => [];
}

class FetchCompanyDetailsEvent extends EditcompanyEvent {
  final String companyId;

  FetchCompanyDetailsEvent(this.companyId);
}

class SaveCompanyEvent extends EditcompanyEvent {
  final String companyId;
  final Company company;

  SaveCompanyEvent(this.companyId, this.company);
}