package com.taskremind.pro.data

class TaskRepository(private val dao: TaskDao) {
    suspend fun getAllTasks(): List<TaskEntity> = dao.getAll()
    suspend fun addTask(task: TaskEntity): Int = dao.insert(task).toInt()
    suspend fun updateTask(task: TaskEntity) = dao.update(task)
    suspend fun deleteTask(task: TaskEntity) = dao.delete(task)
    suspend fun getTask(id: Int): TaskEntity? = dao.findById(id)
}
