part of 'deletecompany_bloc.dart';

abstract class DeletecompanyEvent extends Equatable {
  const DeletecompanyEvent();

  @override
  List<Object> get props => [];
}

class FetchCompanyDetailsEvent extends DeletecompanyEvent {
  final String companyId;

  FetchCompanyDetailsEvent(this.companyId);
}

class DeleteCompanyFromAll extends DeletecompanyEvent {
  final String companyId;
  final List<Map<String, dynamic>> companyIds;
  DeleteCompanyFromAll({this.companyIds, this.companyId});
}

class DeleteCompanyEvent extends DeletecompanyEvent {
  final String companyId;
  final List<Map<String, dynamic>> companyIds;
  final List<String> activeMarkets;
  DeleteCompanyEvent({this.companyId, this.companyIds, this.activeMarkets});
}
