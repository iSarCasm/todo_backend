json.id project.id
json.title project.title
json.desc project.desc
json.in_active project.in_active?
json.shared_url project.shared_url
json.tasks project.tasks, partial: 'v1/tasks/task', as: :task
