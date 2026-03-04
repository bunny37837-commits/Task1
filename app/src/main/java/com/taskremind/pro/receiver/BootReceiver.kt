package com.taskremind.pro.receiver

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import com.taskremind.pro.data.AppDatabase
import com.taskremind.pro.data.TaskRepository
import com.taskremind.pro.util.AppPrefs
import com.taskremind.pro.util.ReminderScheduler
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch

class BootReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent?) {
        val action = intent?.action ?: return
        if (action != Intent.ACTION_BOOT_COMPLETED && action != Intent.ACTION_MY_PACKAGE_REPLACED) return

        CoroutineScope(Dispatchers.IO).launch {
            val prefs = AppPrefs(context)
            if (!prefs.globalEnabled) return@launch

            val repo = TaskRepository(AppDatabase.getInstance(context).taskDao())
            repo.getAllTasks().forEach { task ->
                if (task.enabled) ReminderScheduler.scheduleDaily(context, task)
            }
        }
    }
}
