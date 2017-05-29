json.id comment.id
json.task_id comment.task_id
json.user_name comment.author.name
json.user_avatar comment.author.avatar_url
json.content comment.content
json.attachments comment.attachments.map(&:url)
