package com.example.safe_surf

import android.app.Activity
import android.app.admin.DevicePolicyManager
import android.content.ComponentName
import android.content.Context
import android.os.Bundle
import android.widget.Button
import android.widget.EditText
import android.widget.TextView
import android.view.WindowManager
import android.util.Log

class PasswordPromptActivity : Activity() {
    private lateinit var passwordManager: NativePasswordManager
    private lateinit var devicePolicyManager: DevicePolicyManager
    private lateinit var componentName: ComponentName

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.password_prompt)

        window.addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON or
                        WindowManager.LayoutParams.FLAG_DISMISS_KEYGUARD or
                        WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED or
                        WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON)

        passwordManager = NativePasswordManager(this)
        devicePolicyManager = getSystemService(Context.DEVICE_POLICY_SERVICE) as DevicePolicyManager
        componentName = ComponentName(this, MyDeviceAdminReceiver::class.java)

        val input = findViewById<EditText>(R.id.password_input)
        val errorTextView = findViewById<TextView>(R.id.error_message)
        val submitButton = findViewById<Button>(R.id.submit_button)

        submitButton.setOnClickListener {
            val password = input.text.toString()
            if (passwordManager.verifyPassword(password)) {
                Log.d("SafeSurf", "Correct password entered")
                if (intent.getBooleanExtra("fromAdminDisable", false)) {
                    Log.d("SafeSurf", "Removing active admin")
                    devicePolicyManager.removeActiveAdmin(componentName)
                }
                finish()
            } else {
                Log.d("SafeSurf", "Incorrect password entered")
                errorTextView.text = "Incorrect password. Please try again."
                errorTextView.visibility = TextView.VISIBLE
            }
        }
    }

    override fun onBackPressed() {
        // Prevent closing the activity with the back button
    }
}
