import '../../models/current_user.dart';
import '../storage/user_storage.dart';

class SessionManager {
  SessionManager._();

  static final SessionManager instance = SessionManager._();

  CurrentUser? _currentUser;

  CurrentUser? get currentUser => _currentUser;

  Future<void> initialize() async {
    _currentUser = await UserStorage().get();
  }

  Future<void> refresh() async {
    _currentUser = await UserStorage().get();
  }

  Future<void> clear() async {
    _currentUser = null;
    await UserStorage().clear();
  }
}