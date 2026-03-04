package com.taskremind.pro.receiver

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.provider.Settings
import com.taskremind.pro.data.AppDatabase
import com.taskremind.pro.data.TaskRepository
import com.taskremind.pro.ui.OverlayActivity
import com.taskremind.pro.util.AppPrefs
import com.taskremind.pro.util.ReminderScheduler
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch

class ReminderReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent?) {
        val taskId = intent?.getIntExtra(EXTRA_TASK_ID, -1) ?: -1
        if (taskId <= 0) return

        val pendingResult = goAsync()
        CoroutineScope(Dispatchers.IO).launch {
            try {
                val prefs = AppPrefs(context)
                if (!prefs.globalEnabled) return@launch

                val repo = TaskRepository(AppDatabase.getInstance(context).taskDao())
                val task = repo.getTask(taskId) ?: return@launch

                if (Settings.canDrawOverlays(context)) {
                    val overlayIntent = Intent(context, OverlayActivity::class.java).apply {
                        addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_SINGLE_TOP)
                        putExtra(EXTRA_TASK_ID, task.id)
                        putExtra(EXTRA_TASK_TITLE, task.title)
                    }
                    context.startActivity(overlayIntent)
                }

                ReminderScheduler.scheduleDaily(context, task)
            } finally {
                pendingResult.finish()
            }
        }
    }

    companion object {
        const val EXTRA_TASK_ID = "extra_task_id"
        const val EXTRA_TASK_TITLE = "extra_task_title"
    }
}
