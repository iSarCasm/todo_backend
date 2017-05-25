json.uid @user.uid
json.name @user.name
json.email @user.email
json.avatar @user.avatar_url
json.projects @user.projects, partial: 'v1/projects/project', as: :project
