json.name task.name
json.desc task.desc
json.deadline task.deadline
json.comments task.comments do |comment|
  json.content comment.content
end
