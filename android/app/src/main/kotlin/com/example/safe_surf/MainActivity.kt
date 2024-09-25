package com.example.safe_surf

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.content.Intent

class MainActivity: FlutterActivity() {
    private val DEVICE_ADMIN_CHANNEL = "com.example.safe_surf/device_admin"
    private val PASSWORD_CHANNEL = "com.example.safe_surf/password"
    private lateinit var deviceAdminChannel: MethodChannel
    private lateinit var passwordChannel: MethodChannel
    private lateinit var deviceAdminManager: DeviceAdminManager
    
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)        

        deviceAdminChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, DEVICE_ADMIN_CHANNEL)
        passwordChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, PASSWORD_CHANNEL)
        deviceAdminManager = DeviceAdminManager(this)

        // Password channel setup
        passwordChannel.setMethodCallHandler { call, result ->
            when (call.method) {
                "isPasswordSet" -> {
                    // TODO: Implement isPasswordSet logic
                    result.success(true) // Placeholder, replace with actual implementation
                }
                "verifyPassword" -> {
                    val password = call.argument<String>("password")
                    // TODO: Implement verifyPassword logic
                    result.success(true) // Placeholder, replace with actual implementation
                }
                else -> {
                    result.notImplemented()
                }
            }
        }

        // Device admin channel setup
        deviceAdminChannel.setMethodCallHandler { call, result ->
           when (call.method) {
                "isAdminActive" -> {
                    result.success(deviceAdminManager.isAdminActive())
                }
                "requestAdminPrivileges" -> {
                    deviceAdminManager.requestAdminPrivileges(this)
                    result.success(null)
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

    // override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {    
    //     super.onActivityResult(requestCode, resultCode, data)    
    //     if (requestCode == DeviceAdminManager.REQUEST_CODE_ENABLE_ADMIN) {    
    //         if (resultCode == RESULT_OK) {    
    //             // TODO: Admin privileges granted    
    //         } else {    
    //             // TODO: Admin privileges not granted    
    //         }    
    //     }    
    // }    
}


