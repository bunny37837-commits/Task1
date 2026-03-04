package com.taskremind.pro.util

import android.content.Context

class AppPrefs(context: Context) {
    private val prefs = context.getSharedPreferences("taskremind_prefs", Context.MODE_PRIVATE)

    var globalEnabled: Boolean
        get() = prefs.getBoolean(KEY_GLOBAL_ENABLED, true)
        set(value) = prefs.edit().putBoolean(KEY_GLOBAL_ENABLED, value).apply()

    var darkModeEnabled: Boolean
        get() = prefs.getBoolean(KEY_DARK_MODE, false)
        set(value) = prefs.edit().putBoolean(KEY_DARK_MODE, value).apply()

    companion object {
        private const val KEY_GLOBAL_ENABLED = "global_enabled"
        private const val KEY_DARK_MODE = "dark_mode"
    }
}
