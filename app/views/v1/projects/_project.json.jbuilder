json.title project.title
json.desc project.desc
json.in_active project.in_active?
json.tasks project.tasks, partial: 'v1/tasks/task', as: :task
