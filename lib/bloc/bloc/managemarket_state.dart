part of 'managemarket_bloc.dart';

abstract class ManagemarketState extends Equatable {
  const ManagemarketState();
  @override
  List<Object> get props => [];
}

class ManagemarketInitial extends ManagemarketState {
  @override
  List<Object> get props => [];
}

class ManagemarketLoaded extends ManagemarketState {
  final List<String> marketDataList;
  final List<MarketTypeData> companyList;
  final int selectedIndex;
  final MarketTypeData selectedData;
  final String message;
  ManagemarketLoaded(this.marketDataList, this.selectedIndex,
      {this.companyList, this.selectedData, this.message});

  @override
  List<Object> get props =>
      [marketDataList, selectedIndex, selectedData, message];
}

class ManagemarketResetState extends ManagemarketState {
  final List<String> marketDataList;
  final List<MarketTypeData> companyList;
  final int selectedIndex;
  final MarketTypeData selectedData;

  ManagemarketResetState(
      {@required this.marketDataList,
      this.selectedIndex,
      this.selectedData,
      this.companyList});

  @override
  List<Object> get props => [marketDataList, selectedIndex, selectedData];
}
