package com.example.safe_surf

import android.app.admin.DeviceAdminReceiver
import android.content.Context
import android.content.Intent

class MyDeviceAdminReceiver : DeviceAdminReceiver() {
    override fun onDisableRequested(context: Context, intent: Intent): CharSequence {
        // Lock the screen
        val devicePolicyManager = context.getSystemService(Context.DEVICE_POLICY_SERVICE) as android.app.admin.DevicePolicyManager
        devicePolicyManager.lockNow()
        
        return "Disabling device admin will remove security features of this app."
    }
}