import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

import '../../infrastructure/network/dio_client.dart';
import '../models/pending_message.model.dart';
import 'favorites_storage_service.dart';
import 'pending_messages_storage_service.dart';

class SyncService extends GetxService {
  final PendingMessagesStorageService _pendingMessagesService;
  final FavoritesStorageService _favoritesService;

  final RxBool isOnline = true.obs;

  final RxBool isSyncing = false.obs;

  final RxInt pendingCount = 0.obs;

  Timer? _syncTimer;

  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  static const Duration syncInterval = Duration(seconds: 30);

  static const Duration minSyncDelay = Duration(seconds: 5);

  DateTime? _lastSyncTime;

  SyncService({
    required PendingMessagesStorageService pendingMessagesService,
    required FavoritesStorageService favoritesService,
  })  : _pendingMessagesService = pendingMessagesService,
        _favoritesService = favoritesService;

  @override
  void onInit() {
    super.onInit();
    _initConnectivityListener();
    _startPeriodicSync();
    _updatePendingCount();

    _pendingMessagesService.pendingChanges.listen((_) {
      _updatePendingCount();
    });
  }

  @override
  void onClose() {
    _syncTimer?.cancel();
    _connectivitySubscription?.cancel();
    super.onClose();
  }

  void _initConnectivityListener() {
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      final wasOffline = !isOnline.value;
      isOnline.value = results.isNotEmpty && 
          !results.contains(ConnectivityResult.none);

      if (wasOffline && isOnline.value) {
        syncNow();
      }
    });

    Connectivity().checkConnectivity().then((results) {
      isOnline.value = results.isNotEmpty && 
          !results.contains(ConnectivityResult.none);
    });
  }

  void _startPeriodicSync() {
    _syncTimer?.cancel();
    _syncTimer = Timer.periodic(syncInterval, (_) {
      if (isOnline.value && !isSyncing.value) {
        syncNow();
      }
    });
  }

  Future<void> syncNow() async {
    if (_lastSyncTime != null) {
      final elapsed = DateTime.now().difference(_lastSyncTime!);
      if (elapsed < minSyncDelay) return;
    }

    if (!isOnline.value || isSyncing.value) return;

    isSyncing.value = true;
    _lastSyncTime = DateTime.now();

    try {
      await _syncPendingMessages();

      await _syncFavorites();

    } catch (e) {
      print('Sync error: $e');
    } finally {
      isSyncing.value = false;
      _updatePendingCount();
    }
  }

  Future<void> _syncPendingMessages() async {
    while (_pendingMessagesService.hasPendingMessages) {
      final message = _pendingMessagesService.getNextPending();
      if (message == null) break;

      await _sendMessage(message);
    }
  }

  Future<void> _sendMessage(PendingMessage message) async {
    try {
      await _pendingMessagesService.markAsSending(message.localId);

      // TODO: Remplacer par le vrai endpoint
      final dioClient = Get.find<DioClient>();
      
      final response = await dioClient.dio.post(
        '/messages/send',
        data: message.toApiPayload(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final serverId = response.data?['id']?.toString();
        await _pendingMessagesService.markAsSent(
          message.localId,
          serverId: serverId,
        );
      } else {
        throw Exception('Failed to send message: ${response.statusCode}');
      }
    } catch (e) {
      await _pendingMessagesService.markAsFailed(
        message.localId,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> _syncFavorites() async {
    final unsyncedFavorites = _favoritesService.getUnsyncedFavorites();
    if (unsyncedFavorites.isEmpty) return;

    try {
      final dioClient = Get.find<DioClient>();

      for (final favorite in unsyncedFavorites) {
        try {
          // TODO: Remplacer par le vrai endpoint
          final response = await dioClient.dio.post(
            '/favorites',
            data: {
              'property_id': favorite.propertyId,
              'added_at': favorite.addedAt.toIso8601String(),
            },
          );

          if (response.statusCode == 200 || response.statusCode == 201) {
            await _favoritesService.markAsSynced(favorite.propertyId);
          }
        } catch (e) {
          print('Failed to sync favorite ${favorite.propertyId}: $e');
        }
      }
    } catch (e) {
      print('Favorites sync error: $e');
    }
  }

  void _updatePendingCount() {
    pendingCount.value = _pendingMessagesService.pendingCount;
  }

  Future<int> retryAllFailed() async {
    final count = await _pendingMessagesService.retryAllFailed();
    if (count > 0) {
      await syncNow();
    }
    return count;
  }

  Future<void> cleanup() async {
    await _pendingMessagesService.cleanupSent(
      olderThan: const Duration(days: 30),
    );
  }
}

class SyncServiceFactory {
  static SyncService create() {
    final pendingMessagesService = Get.find<PendingMessagesStorageService>();
    final favoritesService = Get.find<FavoritesStorageService>();

    return SyncService(
      pendingMessagesService: pendingMessagesService,
      favoritesService: favoritesService,
    );
  }
}
