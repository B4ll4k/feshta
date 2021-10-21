import 'package:feshta/scoped-models/connected_models.dart';
import 'package:scoped_model/scoped_model.dart';

class MainModel extends Model
    with ConnectedModel, UserModel, EventModel, HostModel, ArtistModel {}
