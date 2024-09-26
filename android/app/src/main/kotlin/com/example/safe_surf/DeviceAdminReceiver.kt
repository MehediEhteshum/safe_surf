package com.example.safe_surf

import android.app.admin.DeviceAdminReceiver
import android.content.Context
import android.content.Intent
import android.app.AlertDialog
import android.widget.EditText
import android.view.WindowManager
import android.view.LayoutInflater
import android.view.View
import android.widget.TextView
import io.flutter.plugin.common.MethodChannel
import io.flutter.embedding.engine.FlutterEngine

class MyDeviceAdminReceiver : DeviceAdminReceiver() {
    private lateinit var channel: MethodChannel
    private val CHANNEL = "com.example.safe_surf/password"
    private var passwordDialog: AlertDialog? = null
    private lateinit var errorTextView: TextView

    override fun onDisableRequested(context: Context, intent: Intent): CharSequence {
        setupMethodChannel(context)
        val devicePolicyManager = context.getSystemService(Context.DEVICE_POLICY_SERVICE) as android.app.admin.DevicePolicyManager
        
        channel.invokeMethod("isPasswordSet", null, object : MethodChannel.Result {
            override fun success(result: Any?) {
                if (result as Boolean) {
                    showPasswordPrompt(context)
                }
            }

            override fun error(errorCode: String, errorMessage: String?, errorDetails: Any?) {
                // TODO: Handle error
            }

            override fun notImplemented() {
                // TODO: Handle not implemented
            }
        })

        // Lock the screen
        devicePolicyManager.lockNow()

        return "Disabling device admin will remove security features of this app."
    }

    private fun setupMethodChannel(context: Context) {
        val flutterEngine = (context.applicationContext as FlutterApplication).flutterEngine
        channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
    }

    private fun showPasswordPrompt(context: Context, errorMessage: String? = null) {
        if (passwordDialog == null) {
            val builder = AlertDialog.Builder(context)
            builder.setTitle("Enter Password")
            builder.setCancelable(false)  // Prevent dismissing by tapping outside

            val inflater = LayoutInflater.from(context)
            val view = inflater.inflate(R.layout.password_prompt, null)
            val input = view.findViewById<EditText>(R.id.password_input)
            errorTextView = view.findViewById(R.id.error_message)
            builder.setView(view)

            builder.setPositiveButton("OK") { _, _ ->
                val password = input.text.toString()
                verifyPassword(context, password)
            }

            passwordDialog = builder.create()
            passwordDialog?.window?.setType(WindowManager.LayoutParams.TYPE_SYSTEM_ALERT)
        }

        errorTextView.text = errorMessage ?: ""
        errorTextView.visibility = if (errorMessage != null) View.VISIBLE else View.GONE

        passwordDialog?.show()
    }

    private fun dismissPasswordPrompt() {
        passwordDialog?.dismiss()
        passwordDialog = null
    }

    private fun verifyPassword(context: Context, password: String) {
        channel.invokeMethod(
            "verifyPassword",
            password,
            object : MethodChannel.Result {
                override fun success(result: Any?) {
                    if (result as Boolean) {
                        dismissPasswordPrompt()
                    } else {
                        showPasswordPrompt(context, "Incorrect password. Please try again.")
                    }
                }

                override fun error(errorCode: String, errorMessage: String?, errorDetails: Any?) {
                    // TODO: Handle error
                }

                override fun notImplemented() {
                    // TODO: Handle not implemented
                }
            }
        )
    }
}