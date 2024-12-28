import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:embedded_rov_v2/core/common/entities/mqtt_client.dart';
import 'package:embedded_rov_v2/core/secrets/app_secrets.dart';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MqttService extends ChangeNotifier {
  final MQTTConnStateEntity _connState = MQTTConnStateEntity();
  final MqttServerClient _client = MqttServerClient(
    AppSecrets.clusterUrl,
    '${AppSecrets.clientIdentifier ?? "defaultCluster"}-${Random().nextInt(1000000).toString().padLeft(6, '0')}',
  );
  final List<String> _topics = [
    'rov/camera/status',
    'rov/device/status',
    'rov/device/info',
    'rov/expedition',
    'rov/expedition/status',
    'rov/events',
    'controller/movement',
    'controller/depthControl',
  ];

  final StreamController<bool> _cameraStatusController =
      StreamController<bool>.broadcast();
  final StreamController<bool> _deviceStatusController =
      StreamController<bool>.broadcast();
  final StreamController<int> _currentExpeditionController =
      StreamController<int>.broadcast();
  final StreamController<bool> _expeditionStatusController =
      StreamController<bool>.broadcast();
  final StreamController<Map<String, String>> _deviceInfoController =
      StreamController<Map<String, String>>.broadcast();
  final StreamController<String> _controllerMovementController =
      StreamController<String>.broadcast();
  final StreamController<Map<String, dynamic>> _rovEventController =
      StreamController<Map<String, dynamic>>.broadcast();

  Stream<bool> get cameraStatusStream => _cameraStatusController.stream;
  Stream<bool> get deviceStatusStream => _deviceStatusController.stream;
  Stream<int> get currentExpedition => _currentExpeditionController.stream;
  Stream<bool> get expeditionStatusStream => _expeditionStatusController.stream;
  Stream<Map<String, String>> get deviceInfoStream =>
      _deviceInfoController.stream;
  Stream<String> get controllerMovementStream =>
      _controllerMovementController.stream;
  Stream<Map<String, dynamic>> get rovEventStream => _rovEventController.stream;

  void initializeMQTTClient() {
    _client.useWebSocket = true;
    _client.port = int.parse(AppSecrets.clusterPort);
    _client.websocketProtocols = MqttClientConstants.protocolsSingleDefault;
    _client.logging(on: true);
    _client.setProtocolV311();
    _client.keepAlivePeriod = 20;

    _client.onDisconnected = onDisconnected;
    _client.onConnected = onConnected;
    _client.onSubscribed = onSubscribed;
    _client.onUnsubscribed = onUnsubscribed;

    final connMess = MqttConnectMessage()
        .withClientIdentifier(AppSecrets.clientIdentifier)
        .authenticateAs(AppSecrets.clusterUsername.toString(),
            AppSecrets.clusterPassword.toString())
        .withWillTopic('willtopic')
        .withWillMessage('My Will message')
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);
    print('Connecting to broker...');
    _client.connectionMessage = connMess;
  }

  Future<void> connect() async {
    initializeMQTTClient();
    try {
      print('Start client connecting....');
      _connState.setAppConnectionState(MQTTAppConnectionState.connecting);
      updateState();
      await _client.connect();
    } on Exception catch (e) {
      print('Client exception - $e');
      disconnect();
    }
  }

  void onConnected() {
    _connState.setAppConnectionState(MQTTAppConnectionState.connected);
    updateState();
    subScribeToTopics();

    _client.updates!.listen(
      (List<MqttReceivedMessage<MqttMessage?>>? c) {
        final MqttPublishMessage recMessage =
            c![0].payload as MqttPublishMessage;
        final String message = MqttPublishPayload.bytesToStringAsString(
            recMessage.payload.message);
        final String topic = c[0].topic;

        print('Received message: $message from topic: $topic');

        try {
          switch (topic) {
            case 'rov/camera/status':
            case 'rov/expedition/status':
            case 'rov/device/status':
              final Map<String, dynamic> jsonMessage = jsonDecode(message);
              if (jsonMessage.containsKey('isActive')) {
                final bool isActive = jsonMessage['isActive'];
                if (topic == 'rov/camera/status') {
                  _cameraStatusController.add(isActive);
                } else if (topic == 'rov/device/status') {
                  _deviceStatusController.add(isActive);
                } else if (topic == 'rov/expedition/status') {
                  _expeditionStatusController.add(isActive);
                }
              }
              break;

            case 'rov/expedition':
              _currentExpeditionController.add(int.parse(message));
              break;

            case 'rov/events':
              final Map<String, dynamic> jsonMessage = jsonDecode(message);
              _rovEventController.add(jsonMessage);
              break;

            case 'rov/device/info':
              _handleDeviceInfo(message);
              break;

            case 'controller/movement':
            case 'controller/depthControl':
              _controllerMovementController.add(message);
              break;

            default:
              print('Unknown topic: $topic');
          }
        } catch (e) {
          print('Error processing message from topic $topic: $e');
        }

        notifyListeners();
      },
    );
  }

  void onSubscribed(String topic) {
    print('Subscription confirmed for topic $topic');
    _connState
        .setAppConnectionState(MQTTAppConnectionState.connectedSubscribed);
    updateState();
  }

  void onUnsubscribed(String? topic) {
    print('Unsubscribed confirmed for topic $topic');
    _connState
        .setAppConnectionState(MQTTAppConnectionState.connectedUnsubscribed);
    updateState();
  }

  void onDisconnected() {
    print('Disconnected from the broker.');
    _connState.setAppConnectionState(MQTTAppConnectionState.disconnected);
    updateState();
  }

  void subScribeToTopics() {
    for (var topic in _topics) {
      _client.subscribe(topic, MqttQos.atLeastOnce);
      print('Subscribed to topic: $topic');
    }
  }

  void unsubScribeToTopics() {
    for (var topic in _topics) {
      _client.unsubscribe(topic);
      print('Unsubscribed from topic: $topic');
    }
  }

  void disconnect() {
    print('Disconnected');
    _client.disconnect();
  }

  void updateState() {
    notifyListeners();
  }

  void publish(String topic, String message,
      {bool retain = false, MqttQos qos = MqttQos.exactlyOnce}) {
    final builder = MqttClientPayloadBuilder();
    builder.addString(message);

    _client.publishMessage(topic, qos, builder.payload!, retain: retain);
    print('Message published: $message, Retained: $retain, QoS: $qos');
  }

  void _handleDeviceInfo(String message) {
    try {
      final Map<String, dynamic> parsedMessage = json.decode(message);
      final Map<String, String> deviceInfo = parsedMessage.map(
        (key, value) => MapEntry(key, value.toString()),
      );
      _deviceInfoController.add(deviceInfo);
    } catch (e) {
      print('Error parsing device info message: $e');
    }
  }

  @override
  void dispose() {
    _cameraStatusController.close();
    _deviceStatusController.close();
    _deviceInfoController.close();
    _controllerMovementController.close();
    super.dispose();
  }
}
