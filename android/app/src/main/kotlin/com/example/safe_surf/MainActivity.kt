package com.example.safe_surf

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.content.Intent
import android.util.Log
import android.app.admin.DevicePolicyManager
import android.content.ComponentName
import android.content.Context

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.safe_surf/device_admin"
    private lateinit var deviceAdminManager: DeviceAdminManager
    private lateinit var passwordManager: NativePasswordManager
    
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)        

        deviceAdminManager = DeviceAdminManager(this)
        passwordManager = NativePasswordManager(this)

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
                "setPassword" -> {
                    val password = call.argument<String>("password")
                    if (password != null) {
                        passwordManager.setPassword(password)
                        result.success(true)
                    } else {
                        result.error("INVALID_ARGUMENT", "Password cannot be null", null)
                    }
                }
                "isPasswordSet" -> {
                    result.success(passwordManager.isPasswordSet())
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
            val isAdminActive = deviceAdminManager.isAdminActive()
            Log.d("SafeSurf", "Admin activation result: $isAdminActive")
            flutterEngine?.dartExecutor?.binaryMessenger?.let { messenger ->
                MethodChannel(messenger, CHANNEL).invokeMethod("onAdminResult", isAdminActive)
            } ?: run {
                Log.e("SafeSurf", "Failed to get BinaryMessenger")
            }
        }    
    }
}
