json.id task.id
json.project_id task.project_id
json.name task.name
json.desc task.desc
json.deadline task.deadline
json.finished task.finished?
json.position task.position
json.comments task.comments, partial: 'v1/comments/comment', as: :comment
