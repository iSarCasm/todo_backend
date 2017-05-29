module V1
  class TasksController < ApplicationController
    before_action :authenticate_user!
    before_action :set_task, except: [:create]
    authorize_resource

    api! "Create a new task"
    description "Creates a new task under given project"
    param :project_id, Fixnum, desc: 'Target project', required: true
    param :task, Hash, desc: 'Task info' do
      param :name, String, desc: 'Name of the new task (max length is 80)', required: true
      param :desc, String, desc: 'Task description (max length is 300)'
      param :deadline, String, desc: 'Time when needed to finish the project'
      param :position, Fixnum, desc: 'Task position relative to other projects under this task (auto set to highest)'
    end
    error 401, 'Unauthorized'
    error 422, 'Parameter missing'
    example <<~EOS
      REQUEST:
      {
        "project_id"=>"16",
        "task"=>{
          "name"=>"New task",
          "desc"=>"Some long description",
          "deadline"=>"2017-05-28"
        }
      }
      RESPONSE:
      {
         "id"=>55,
         "project_id"=>16,
         "name"=>"New task",
         "desc"=>"Some long description",
         "deadline"=>"2017-05-28",
         "finished"=>false,
         "position"=>4,
         "comments"=>[{...}, ...]
       }
    EOS
    def create
      @task = get_project.tasks.create!(task_params)
      render @task
    end

    api! "Update task"
    description "Updates given task. Task has to be owned by current user. Returns updated task object upon success."
    param :id, Fixnum, desc: 'Task id', required: true
    param :task, Hash, desc: 'Task info' do
      param :name, String, desc: 'Name of the new task (max length is 80)'
      param :desc, String, desc: 'Task description (max length is 300)'
      param :deadline, String, desc: 'Time when needed to finish the project'
      param :position, Fixnum, desc: 'Task position relative to other projects under this task (auto set to highest)'
    end
    error 401, 'Unauthorized'
    error 422, 'Parameter missing'
    see 'tasks#create', 'tasks#create'
    def update
      @task.update!(task_params)
      render @task
    end

    api! 'Finish task'
    description 'Marks given task as finished. Returns updated task object upon success.'
    param :id, Fixnum, desc: 'Task id', required: true
    error 401, 'Unauthorized'
    error 404, 'Not found'
    def finish
      @task.finish!
      render @task
    end

    api! 'To progress task'
    description 'Marks given task as `in progress`. Returns updated task object upon success.'
    param :id, Fixnum, desc: 'Task id', required: true
    error 401, 'Unauthorized'
    error 404, 'Not found'
    def to_progress
      @task.to_progress!
      render @task
    end

    api! "Delete task"
    description "Delete given task. Task has to be owned by current user. Returns task object upon success."
    param :id, Fixnum, desc: 'Task id', required: true
    error 401, 'Unauthorized'
    error 404, 'Not found'
    def destroy
      @task.destroy!
      render @task
    end

    private

    def task_params
      params.require(:task).permit(:name, :desc, :deadline, :position)
    end

    def set_task
      @task = current_user.tasks.find(params[:id])
    end

    def get_project
      current_user.projects.find(params[:project_id])
    end
  end
end
