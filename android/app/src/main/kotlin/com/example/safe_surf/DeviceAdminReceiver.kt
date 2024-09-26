package com.example.safe_surf

import android.app.admin.DeviceAdminReceiver
import android.content.Context
import android.content.Intent
import android.util.Log
import android.os.Handler
import android.os.Looper

class MyDeviceAdminReceiver : DeviceAdminReceiver() {
    private lateinit var passwordManager: NativePasswordManager

    override fun onDisableRequested(context: Context, intent: Intent): CharSequence {
        Log.d("SafeSurf", "onDisableRequested called")
        try {
            passwordManager = NativePasswordManager(context)
            val devicePolicyManager = context.getSystemService(Context.DEVICE_POLICY_SERVICE) as android.app.admin.DevicePolicyManager
            
            if (passwordManager.isPasswordSet()) {
                Log.d("SafeSurf", "Password is set, launching PasswordPromptActivity")
                val promptIntent = Intent(context, PasswordPromptActivity::class.java).apply {
                    addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                }
                context.startActivity(promptIntent)
            } else {
                Log.d("SafeSurf", "Password not set, skipping prompt")
            }

            Log.d("SafeSurf", "Locking screen")
            Handler(Looper.getMainLooper()).postDelayed({
                devicePolicyManager.lockNow()
            }, 500) // Delay to ensure the PasswordPromptActivity is shown before locking
        } catch (e: Exception) {
            Log.e("SafeSurf", "Exception in onDisableRequested", e)
        }

        return "Disabling device admin will remove security features of this app."
    }
}
