part of 'managemarket_bloc.dart';

@immutable
abstract class ManagemarketEvent {}

class FetchMarketData extends ManagemarketEvent {}

class ChangeSelectedIndex extends ManagemarketEvent {
  final int selectedIndex;

  ChangeSelectedIndex(this.selectedIndex);
}

class SetSelectedData extends ManagemarketEvent {
  final MarketTypeData marketTypeData;

  SetSelectedData(this.marketTypeData);
}

class UpdateManageData extends ManagemarketEvent {
  final MarketTypeData updatedData;

  UpdateManageData(this.updatedData);
}
