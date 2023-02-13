import 'dart:async';
import 'dart:ffi';

import 'package:clean_architecture/domain/models/models.dart';
import 'package:clean_architecture/domain/usecases/getStoreDetails_usecase.dart';
import 'package:clean_architecture/presentation/base/base_view_model.dart';
import 'package:clean_architecture/presentation/common/render_state/render_state.dart';
import 'package:clean_architecture/presentation/common/render_state/render_state_impl.dart';
import 'package:rxdart/subjects.dart';

class StoreDetailsViewModel extends BaseViewModel with Inputs, Outputs {
  final GetStoreDetailsUseCase _getStoreDetailsUseCase;
  StoreDetailsViewModel(this._getStoreDetailsUseCase);

  final _itemDetailsStreamController = BehaviorSubject<StoreDetails>();

  @override
  void start() {
    getStoreDetails();
  }

  @override
  void dispose() {
    _itemDetailsStreamController.close();
    super.dispose();
  }

  @override
  getStoreDetails() async {
    inputState.add(
        LoadingState(stateRenderType: StateRenderType.fullScreenLoadingState));
    (await _getStoreDetailsUseCase.execute(Void)).fold(
      (failure) {
        inputState.add(
            ErrorState(StateRenderType.fullScreenErrorState, failure.message));
      },
      (storeDetails) async {
        inputState.add(ContentState());
        inputItemDetails.add(storeDetails);
      },
    );
  }

  @override
  Sink get inputItemDetails => _itemDetailsStreamController.sink;

  @override
  Stream<StoreDetails> get OutputItemDetails =>
      _itemDetailsStreamController.stream.map((data) => data);
}

abstract class Inputs {
  getStoreDetails();

  Sink get inputItemDetails;
}

abstract class Outputs {
  Stream<StoreDetails> get OutputItemDetails;
}
