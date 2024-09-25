package com.example.safe_surf

import android.app.admin.DeviceAdminReceiver
import android.content.Context
import android.content.Intent
import android.app.AlertDialog
import android.widget.EditText
import android.view.WindowManager
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.plugin.common.MethodChannel

class MyDeviceAdminReceiver : DeviceAdminReceiver() {
    private val CHANNEL = "com.example.safe_surf/password"

    override fun onDisableRequested(context: Context, intent: Intent): CharSequence {
        val devicePolicyManager = context.getSystemService(Context.DEVICE_POLICY_SERVICE) as android.app.admin.DevicePolicyManager
        
        checkPasswordAndPrompt(context)
        
        // Lock the screen
        devicePolicyManager.lockNow()
        
        return "Disabling device admin will remove security features of this app."
    }

    private fun checkPasswordAndPrompt(context: Context) {
        val flutterEngine = FlutterEngine(context)
        flutterEngine.dartExecutor.executeDartEntrypoint(DartExecutor.DartEntrypoint.createDefault())

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).invokeMethod(
            "isPasswordSet",
            null,
            object : MethodChannel.Result {
                override fun success(result: Any?) {
                    if (result as Boolean) {
                        showPasswordPrompt(context)
                    }
                }

                override fun error(errorCode: String, errorMessage: String?, errorDetails: Any?) {
                    // Handle error
                }

                override fun notImplemented() {
                    // Handle not implemented
                }
            }
        )
    }

    private fun showPasswordPrompt(context: Context) {
        val builder = AlertDialog.Builder(context)
        builder.setTitle("Enter Password")
        builder.setCancelable(false)  // Prevent dismissing by tapping outside

        val input = EditText(context)
        builder.setView(input)

        builder.setPositiveButton("OK") { _, _ ->
            val password = input.text.toString()
            // TODO: Verify password (we'll implement this in the next step)
        }

        val dialog = builder.create()
        dialog.window?.setType(WindowManager.LayoutParams.TYPE_SYSTEM_ALERT)
        dialog.show()
    }
}