json.tasks @tasks do |task|
  json.id        task.id
  json.progress  task.progress
  json.worker_id task.worker_id
  json.uid       task.uid
end
