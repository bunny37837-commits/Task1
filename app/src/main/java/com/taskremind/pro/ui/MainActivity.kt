package com.taskremind.pro.ui

import android.Manifest
import android.app.TimePickerDialog
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.provider.Settings
import android.widget.Toast
import androidx.activity.result.contract.ActivityResultContracts
import androidx.appcompat.app.AppCompatActivity
import androidx.appcompat.app.AppCompatDelegate
import androidx.lifecycle.lifecycleScope
import androidx.recyclerview.widget.LinearLayoutManager
import com.taskremind.pro.data.AppDatabase
import com.taskremind.pro.data.TaskEntity
import com.taskremind.pro.data.TaskRepository
import com.taskremind.pro.databinding.ActivityMainBinding
import com.taskremind.pro.util.AppPrefs
import com.taskremind.pro.util.ReminderScheduler
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import java.util.Calendar
import kotlin.math.max

class MainActivity : AppCompatActivity() {

    private lateinit var binding: ActivityMainBinding
    private lateinit var repository: TaskRepository
    private lateinit var prefs: AppPrefs
    private lateinit var adapter: TaskAdapter

    private var selectedHour = Calendar.getInstance().get(Calendar.HOUR_OF_DAY)
    private var selectedMinute = max(0, Calendar.getInstance().get(Calendar.MINUTE) + 1) % 60
    private var editTarget: TaskEntity? = null

    private val notificationPermissionLauncher =
        registerForActivityResult(ActivityResultContracts.RequestPermission()) { }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityMainBinding.inflate(layoutInflater)
        setContentView(binding.root)

        prefs = AppPrefs(this)
        repository = TaskRepository(AppDatabase.getInstance(this).taskDao())

        initToggles()
        initRecycler()
        initActions()
        maybeAskNotificationPermission()
        refreshTasks()
    }

    private fun initToggles() {
        binding.switchGlobal.isChecked = prefs.globalEnabled
        binding.switchGlobal.setOnCheckedChangeListener { _, checked ->
            prefs.globalEnabled = checked
            if (!checked) {
                lifecycleScope.launch(Dispatchers.IO) {
                    repository.getAllTasks().forEach { ReminderScheduler.cancel(this@MainActivity, it.id) }
                }
            } else {
                refreshTasksAndReschedule()
            }
        }

        binding.switchDarkMode.isChecked = prefs.darkModeEnabled
        binding.switchDarkMode.setOnCheckedChangeListener { _, checked ->
            prefs.darkModeEnabled = checked
            AppCompatDelegate.setDefaultNightMode(
                if (checked) AppCompatDelegate.MODE_NIGHT_YES else AppCompatDelegate.MODE_NIGHT_NO
            )
        }
    }

    private fun initRecycler() {
        adapter = TaskAdapter(
            onEdit = { task ->
                editTarget = task
                selectedHour = task.hour
                selectedMinute = task.minute
                binding.inputTaskTitle.setText(task.title)
                binding.buttonAddTask.text = "Update task"
                binding.buttonPickTime.text = String.format("%02d:%02d", task.hour, task.minute)
            },
            onDelete = { task ->
                lifecycleScope.launch(Dispatchers.IO) {
                    repository.deleteTask(task)
                    ReminderScheduler.cancel(this@MainActivity, task.id)
                    withContext(Dispatchers.Main) { refreshTasks() }
                }
            }
        )
        binding.recyclerTasks.layoutManager = LinearLayoutManager(this)
        binding.recyclerTasks.adapter = adapter
    }

    private fun initActions() {
        binding.buttonPermissions.setOnClickListener {
            startActivity(Intent(this, PermissionsGuideActivity::class.java))
        }

        binding.buttonPickTime.setOnClickListener {
            TimePickerDialog(this, { _, hour, minute ->
                selectedHour = hour
                selectedMinute = minute
                binding.buttonPickTime.text = String.format("%02d:%02d", hour, minute)
            }, selectedHour, selectedMinute, true).show()
        }

        binding.buttonAddTask.setOnClickListener {
            val title = binding.inputTaskTitle.text?.toString()?.trim().orEmpty()
            if (title.isEmpty()) {
                Toast.makeText(this, "Title is required", Toast.LENGTH_SHORT).show()
                return@setOnClickListener
            }

            lifecycleScope.launch(Dispatchers.IO) {
                val existing = editTarget
                if (existing == null) {
                    val id = repository.addTask(TaskEntity(title = title, hour = selectedHour, minute = selectedMinute))
                    ReminderScheduler.scheduleDaily(this@MainActivity, TaskEntity(id = id, title = title, hour = selectedHour, minute = selectedMinute))
                } else {
                    val updated = existing.copy(title = title, hour = selectedHour, minute = selectedMinute)
                    repository.updateTask(updated)
                    ReminderScheduler.scheduleDaily(this@MainActivity, updated)
                }
                withContext(Dispatchers.Main) {
                    clearEditor()
                    refreshTasks()
                }
            }
        }
    }

    private fun clearEditor() {
        editTarget = null
        binding.inputTaskTitle.text = null
        binding.buttonAddTask.text = "Add task"
    }

    private fun refreshTasks() {
        lifecycleScope.launch(Dispatchers.IO) {
            val tasks = repository.getAllTasks()
            withContext(Dispatchers.Main) { adapter.submitList(tasks) }
        }
    }

    private fun refreshTasksAndReschedule() {
        lifecycleScope.launch(Dispatchers.IO) {
            repository.getAllTasks().forEach { ReminderScheduler.scheduleDaily(this@MainActivity, it) }
            withContext(Dispatchers.Main) { refreshTasks() }
        }
    }

    private fun maybeAskNotificationPermission() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            notificationPermissionLauncher.launch(Manifest.permission.POST_NOTIFICATIONS)
        }
        if (!Settings.canDrawOverlays(this)) {
            val intent = Intent(
                Settings.ACTION_MANAGE_OVERLAY_PERMISSION,
                Uri.parse("package:$packageName")
            )
            startActivity(intent)
        }
    }
}
