package com.taskremind.pro.ui

import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import androidx.lifecycle.lifecycleScope
import com.taskremind.pro.data.AppDatabase
import com.taskremind.pro.data.TaskRepository
import com.taskremind.pro.databinding.ActivityOverlayBinding
import com.taskremind.pro.receiver.ReminderReceiver
import com.taskremind.pro.util.ReminderScheduler
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch

class OverlayActivity : AppCompatActivity() {

    private lateinit var binding: ActivityOverlayBinding
    private var taskId: Int = -1

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityOverlayBinding.inflate(layoutInflater)
        setContentView(binding.root)

        taskId = intent.getIntExtra(ReminderReceiver.EXTRA_TASK_ID, -1)
        val taskTitle = intent.getStringExtra(ReminderReceiver.EXTRA_TASK_TITLE).orEmpty()
        binding.textOverlayTask.text = taskTitle

        binding.buttonDone.setOnClickListener { markDoneAndClose() }
        binding.buttonSnooze.setOnClickListener {
            if (taskId > 0) ReminderScheduler.scheduleSnooze(this, taskId, 10)
            finish()
        }
        binding.buttonDismiss.setOnClickListener { finish() }
    }

    private fun markDoneAndClose() {
        if (taskId <= 0) {
            finish()
            return
        }
        lifecycleScope.launch(Dispatchers.IO) {
            val repo = TaskRepository(AppDatabase.getInstance(this@OverlayActivity).taskDao())
            repo.getTask(taskId)?.let {
                // Done keeps task active as a daily reminder, so re-schedule next day.
                ReminderScheduler.scheduleDaily(this@OverlayActivity, it)
            }
            finish()
        }
    }
}
