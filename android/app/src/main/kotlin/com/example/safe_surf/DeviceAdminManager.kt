package com.example.safe_surf

import android.app.admin.DevicePolicyManager
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.app.Activity

class DeviceAdminManager(private val context: Context) {
    private val devicePolicyManager: DevicePolicyManager =
        context.getSystemService(Context.DEVICE_POLICY_SERVICE) as DevicePolicyManager
    private val componentName: ComponentName = ComponentName(context, MyDeviceAdminReceiver::class.java)

    fun isAdminActive(): Boolean {
        return devicePolicyManager.isAdminActive(componentName)
    }

    fun requestAdminPrivileges(activity: Activity) {
        val intent = Intent(DevicePolicyManager.ACTION_ADD_DEVICE_ADMIN).apply {
            putExtra(DevicePolicyManager.EXTRA_DEVICE_ADMIN, componentName)
            putExtra(DevicePolicyManager.EXTRA_ADD_EXPLANATION, "Admin access is required for app security features.")
        }
        activity.startActivityForResult(intent, REQUEST_CODE_ENABLE_ADMIN)
    }

    fun lockScreen() {
        if (isAdminActive()) {
            devicePolicyManager.lockNow()
        }
    }

    fun attemptAdminStatusChange(onPasswordRequired: () -> Unit) {
        if (isAdminActive()) {
            onPasswordRequired()
        }
    }

    companion object {
        const val REQUEST_CODE_ENABLE_ADMIN = 1
    }
}
