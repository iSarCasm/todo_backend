class Stats
  attr_reader :users, :projects, :tasks, :comments

  def initialize
    @users = User.count
    @projects = Project.count
    @tasks = Task.count
    @comments = Comment.count
  end
end
