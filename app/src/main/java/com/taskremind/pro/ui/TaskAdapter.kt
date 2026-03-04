package com.taskremind.pro.ui

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.taskremind.pro.data.TaskEntity
import com.taskremind.pro.databinding.ItemTaskBinding
import java.util.Locale

class TaskAdapter(
    private val onEdit: (TaskEntity) -> Unit,
    private val onDelete: (TaskEntity) -> Unit
) : RecyclerView.Adapter<TaskAdapter.TaskViewHolder>() {

    private val items = mutableListOf<TaskEntity>()

    fun submitList(tasks: List<TaskEntity>) {
        items.clear()
        items.addAll(tasks)
        notifyDataSetChanged()
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): TaskViewHolder {
        val binding = ItemTaskBinding.inflate(LayoutInflater.from(parent.context), parent, false)
        return TaskViewHolder(binding)
    }

    override fun onBindViewHolder(holder: TaskViewHolder, position: Int) {
        holder.bind(items[position])
    }

    override fun getItemCount(): Int = items.size

    inner class TaskViewHolder(private val binding: ItemTaskBinding) : RecyclerView.ViewHolder(binding.root) {
        fun bind(task: TaskEntity) {
            binding.textTitle.text = task.title
            binding.textTime.text = String.format(Locale.getDefault(), "Daily at %02d:%02d", task.hour, task.minute)
            binding.buttonEdit.setOnClickListener { onEdit(task) }
            binding.buttonDelete.setOnClickListener { onDelete(task) }
        }
    }
}
