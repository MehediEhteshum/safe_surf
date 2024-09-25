package com.example.safe_surf

import android.app.admin.DeviceAdminReceiver
import android.content.Context
import android.content.Intent

class MyDeviceAdminReceiver : DeviceAdminReceiver() {
    override fun onDisableRequested(context: Context, intent: Intent): CharSequence {
        val devicePolicyManager = context.getSystemService(Context.DEVICE_POLICY_SERVICE) as android.app.admin.DevicePolicyManager
                
        // TODO: create a password prompt before locking the screen [if the admin status is active, and a password is present in secure storage. Otherwise, ignore the prompt and just proceed to locking the screen] + [so that after unlocking the screen, the password prompt is shown and after giving the correct password, the user can revoke the admin status. If password is incorrect or cancelled, the user needs to try the revocation again OR password prompt cannot be cancelled and if password is incorrect, the user needs to try again and again - whichever is doable.]

        // Lock the screen
        devicePolicyManager.lockNow()
        
        return "Disabling device admin will remove security features of this app."
    }
}