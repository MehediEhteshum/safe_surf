package com.example.safe_surf

import android.app.Application
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.plugin.common.MethodChannel

class FlutterApplication : Application() {
    lateinit var flutterEngine : FlutterEngine

    override fun onCreate() {
        super.onCreate()
        flutterEngine = FlutterEngine(this)

        // Start executing Dart code to pre-warm the FlutterEngine.
        flutterEngine.dartExecutor.executeDartEntrypoint(
            DartExecutor.DartEntrypoint.createDefault()
        )

        // Cache the FlutterEngine to be used by FlutterActivity.
        FlutterEngineCache
            .getInstance()
            .put("my_engine_id", flutterEngine)

        // Set up MethodChannel
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "com.example.safe_surf/device_admin").setMethodCallHandler { call, result ->
            when (call.method) {
                "isAdminActive" -> {
                    val deviceAdminManager = DeviceAdminManager(this)
                    result.success(deviceAdminManager.isAdminActive())
                }
                "requestAdminPrivileges" -> {
                    // This method needs to be handled in MainActivity as it requires an Activity context
                    result.error("UNAVAILABLE", "Just initializing. Cannot request admin privileges from Application context", null)
                }
                "lockScreen" -> {
                    val deviceAdminManager = DeviceAdminManager(this)
                    deviceAdminManager.lockScreen()
                    result.success(null)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }
}
