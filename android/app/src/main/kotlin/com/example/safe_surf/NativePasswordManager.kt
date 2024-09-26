package com.example.safe_surf

import android.content.Context
import androidx.security.crypto.EncryptedSharedPreferences
import androidx.security.crypto.MasterKeys
import android.util.Log

class NativePasswordManager(context: Context) {
    private val masterKeyAlias = MasterKeys.getOrCreate(MasterKeys.AES256_GCM_SPEC)
    private val sharedPreferences = EncryptedSharedPreferences.create(
        "secure_prefs",
        masterKeyAlias,
        context,
        EncryptedSharedPreferences.PrefKeyEncryptionScheme.AES256_SIV,
        EncryptedSharedPreferences.PrefValueEncryptionScheme.AES256_GCM
    )

    fun setPassword(password: String) {
        Log.d("SafeSurf", "Setting password")
        sharedPreferences.edit().putString(PASSWORD_KEY, password).apply()
    }

    fun getPassword(): String? {
        return sharedPreferences.getString(PASSWORD_KEY, null)
    }

    fun isPasswordSet(): Boolean {
        val isSet = !getPassword().isNullOrEmpty()
        Log.d("SafeSurf", "Is password set: $isSet")
        return isSet
    }

    fun verifyPassword(inputPassword: String): Boolean {
        val storedPassword = getPassword()
        val isCorrect = inputPassword == storedPassword
        Log.d("SafeSurf", "Password verification result: $isCorrect")
        return isCorrect
    }

    companion object {
        private const val PASSWORD_KEY = "app_password"
    }
}
