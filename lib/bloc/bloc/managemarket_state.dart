part of 'managemarket_bloc.dart';

@immutable
abstract class ManagemarketState {}

class ManagemarketInitial extends ManagemarketState {}

class ManagemarketLoaded extends ManagemarketState {
  final List<Map<String, List<MarketTypeData>>> marketDataList;
  final int selectedIndex;
  final MarketTypeData selectedData;
  final String message;
  ManagemarketLoaded(this.marketDataList, this.selectedIndex,
      {this.selectedData, this.message});
}

class ManagemarketResetState extends ManagemarketState {
  final List<Map<String, List<MarketTypeData>>> marketDataList;
  final int selectedIndex;
  final MarketTypeData selectedData;

  ManagemarketResetState({@required this.marketDataList, this.selectedIndex, this.selectedData});
}
