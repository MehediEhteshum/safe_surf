package com.example.safe_surf

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.content.Intent
import android.util.Log

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.safe_surf/device_admin"
    private lateinit var deviceAdminManager: DeviceAdminManager
    
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)        

        deviceAdminManager = DeviceAdminManager(this)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
           when (call.method) {
                "requestAdminPrivileges" -> {
                    deviceAdminManager.requestAdminPrivileges(this)
                    result.success(null)
                }
                "isAdminActive" -> {
                    result.success(deviceAdminManager.isAdminActive())
                }
                "lockScreen" -> {
                    deviceAdminManager.lockScreen()
                    result.success(null)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {    
        super.onActivityResult(requestCode, resultCode, data)    
        if (requestCode == DeviceAdminManager.REQUEST_CODE_ENABLE_ADMIN) {    
            if (resultCode == RESULT_OK) {    
                // Admin privileges granted    
                // Inform the Dart side about this
                flutterEngine?.dartExecutor?.binaryMessenger?.let { messenger ->
                    MethodChannel(messenger, CHANNEL).invokeMethod("onAdminResult", true)
                } ?: run {
                    Log.e("MainActivity", "Failed to get BinaryMessenger")
                }
            } else {    
                // Admin privileges not granted    
                // Inform the Dart side about this
                flutterEngine?.dartExecutor?.binaryMessenger?.let { messenger ->
                    MethodChannel(messenger, CHANNEL).invokeMethod("onAdminResult", false)
                } ?: run {
                    Log.e("MainActivity", "Failed to get BinaryMessenger")
                }
            }    
        }    
    }
}