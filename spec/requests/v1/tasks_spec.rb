require 'rails_helper'

RSpec.describe "Tasks API", type: :request do
  let(:user) { FactoryGirl.create(:user_with_projects) }
  let(:other_user) { FactoryGirl.create(:user_with_projects) }

  describe '#create' do
    context 'when logged in' do
      context 'with valid params' do
        it 'creates a new task' do
          time = DateTime.now.to_s
          task_params = { name: "New task", desc: "Some long description", deadline: time }

          v1_auth_post user,
                    tasks_path,
                    params: { project_id: user.projects.first.id, task: task_params}

          expect(response.status).to eq 200
          expect_json(name: "New task", desc: "Some long description", deadline: time)
        end
      end

      context 'with invalid params' do
        it 'fails to create a new task without params' do
          v1_auth_post user, tasks_path
          expect_http_error 422
        end

        it 'fails to create a new task without task params' do
          v1_auth_post user, tasks_path, params: { project_id: user.projects.first.id }
          expect_http_error 422
        end
      end
    end

    context 'when logged out' do
      it 'return 401: Unauthorized' do
        v1_post tasks_path
        expect_http_error 401
      end
    end
  end

  describe '#update' do
    context 'when logged in' do
      context 'with valid params' do
        before do
          @task_params = { name: "New task name" }
        end

        it 'updates the task' do
          v1_auth_patch user, task_path(user.projects.first.tasks.first), params: { task: @task_params }

          expect(response.status).to eq 200
          expect_json(name: "New task name")
          expect_json_types(name: :string, desc: :string, deadline: :string)
        end

        it 'returns 404: Not Found if wrong id specified' do
          v1_auth_patch user, task_path(-10), params: { task: @task_params }
          expect_http_error 404
        end

        context 'editing other user`s task' do
          it 'returns 403: Forbidden when accessing others task' do
            v1_auth_patch user, task_path(other_user.projects.first.tasks.first), params: { task: @task_params }
            expect_http_error 403
          end
        end
      end

      context 'with invalid params' do
        it 'fails to update the task' do
          v1_auth_patch user, task_path(user.projects.first.tasks.first)
          expect_http_error 422
        end
      end
    end

    context 'when logged out' do
      it 'return 401: Unauthorized' do
        task = user.projects.first.tasks.first

        v1_patch task_path(task)

        expect_http_error 401
      end
    end
  end

  describe '#destroy' do
    context 'when logged in' do
      it 'destroys user`s task' do
        task = user.projects.first.tasks.first

        v1_auth_delete user, task_path(task)

        expect(response.status).to eq 200
        expect(Task.exists?(task.id)).to be_falsey
      end

      it 'returns 404: Not Found if wrong id specified' do
        v1_auth_delete user, task_path(-10)
        expect_http_error 404
      end

      it 'does not allow destroying other user`s task' do
        other_task = other_user.projects.first.tasks.first

        v1_auth_delete user, task_path(other_task)

        expect_http_error 403
        expect(Task.exists?(other_task.id)).to be_truthy
      end
    end

    context 'when logged out' do
      it 'return 401: Unauthorized' do
        task = user.projects.first.tasks.first

        v1_delete task_path(task)

        expect_http_error 401
      end
    end
  end

  describe '#finish' do
    context 'when logged in' do
      it 'finishes user`s task' do
        task = user.projects.first.tasks.first

        v1_auth_patch user, finish_task_path(task)

        expect(response.status).to eq 200
        expect(user.projects.first.tasks.first).to be_finished
      end

      it 'returns 404: Not Found if wrong id specified' do
        v1_auth_patch user, finish_task_path(-10)
        expect_http_error 404
      end

      it 'does not allow finishing other user`s task' do
        other_task = other_user.projects.first.tasks.first

        v1_auth_patch user, finish_task_path(other_task)

        expect_http_error 403
        expect(other_user.projects.first.tasks.first).to be_in_progess
      end
    end

    context 'when logged out' do
      it 'return 401: Unauthorized' do
        v1_patch finish_task_path(user.projects.first.tasks.first)
        expect_http_error 401
      end
    end
  end

  describe '#to_progress' do
    context 'when logged in' do
      it 'finishes user`s task' do
        task = user.projects.first.tasks.first
        task.finish!

        v1_auth_patch user, to_progress_task_path(task)

        expect(response.status).to eq 200
        expect(user.projects.first.tasks.first).to be_in_progess
      end

      it 'returns 404: Not Found if wrong id specified' do
        v1_auth_patch user, to_progress_task_path(-10)
        expect_http_error 404
      end

      it 'does not allow finishing other user`s task' do
        other_task = other_user.projects.first.tasks.first
        other_task.finish!

        v1_auth_patch user, to_progress_task_path(other_task)

        expect_http_error 403
        expect(other_user.projects.first.tasks.first).to be_finished
      end
    end

    context 'when logged out' do
      it 'return 401: Unauthorized' do
        v1_patch finish_task_path(user.projects.first.tasks.first)
        expect_http_error 401
      end
    end
  end
end
