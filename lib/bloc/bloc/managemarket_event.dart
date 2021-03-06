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
  final String marketTypeName;
  UpdateManageData(this.updatedData, {this.marketTypeName});
}

class ResetMarketData extends ManagemarketEvent {}

class RefreshMarketData extends ManagemarketEvent {
  final MarketTypeData updatedData;

  RefreshMarketData(this.updatedData);
}
