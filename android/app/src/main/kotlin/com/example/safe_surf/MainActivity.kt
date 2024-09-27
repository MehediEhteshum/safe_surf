package com.example.safe_surf

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.content.Intent

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.safe_surf/device_admin"
    private lateinit var channel: MethodChannel
    private lateinit var deviceAdminManager: DeviceAdminManager
    
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)        

        channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        deviceAdminManager = DeviceAdminManager(this)

        channel.setMethodCallHandler { call, result ->
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


