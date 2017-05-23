require 'rails_helper'

RSpec.describe "Tasks API", type: :request, version: :v1 do
  let(:user) { FactoryGirl.create(:user_with_projects) }
  let(:other_user) { FactoryGirl.create(:user_with_projects) }

  describe '#create' do
    context 'when logged in' do
      context 'with valid params' do
        it 'creates a new task' do
          time = DateTime.now.to_s
          task_params = { name: "New task", desc: "Some long description", deadline: time }
          auth_post user,
                    tasks_path,
                    params: { project_id: user.projects.first.id, task: task_params, format: :json},
                    headers: v1_headers

          expect(response.status).to eq 200
          expect_json(name: "New task", desc: "Some long description", deadline: time)
        end
      end

      context 'with invalid params' do
        it 'fails to create a new task without params' do
          auth_post user, tasks_path, params: { format: :json }, headers: v1_headers

          expect(response.status).to eq 422
          expect(json).to include 'errors'
          expect(json).to_not include 'name'
        end

        it 'fails to create a new task without task params' do
          auth_post user, tasks_path, params: { project_id: user.projects.first.id, format: :json }, headers: v1_headers

          expect(response.status).to eq 422
          expect(json).to include 'errors'
          expect(json).to_not include 'name'
        end
      end
    end

    context 'when logged out' do
      it 'return 401: Unauthorized' do
        post tasks_path, params: { format: :json }, headers: v1_headers

        expect(response.status).to eq 401
        expect(json).to include 'errors'
        expect(json).to_not include 'name'
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
          auth_patch user, task_path(user.projects.first.tasks.first), params: { task: @task_params, format: :json }, headers: v1_headers

          expect(response.status).to eq 200
          expect_json(name: "New task name")
          expect_json_types(name: :string, desc: :string, deadline: :string)
        end

        it 'returns 404: Not Found if wrong id specified' do
          auth_patch user, task_path(-10), params: { task: @task_params, format: :json }, headers: v1_headers

          expect(response.status).to eq 404
          expect(json).to include 'errors'
        end

        context 'editing other user`s task' do
          it 'returns 403: Forbidden when accessing others task' do
            auth_patch user, task_path(other_user.projects.first.tasks.first), params: { task: @task_params, format: :json }, headers: v1_headers

            expect(response.status).to eq 403
            expect(json).to include 'errors'
            expect(json).to_not include 'name'
          end
        end
      end

      context 'with invalid params' do
        it 'fails to update the task' do
          auth_patch user, task_path(user.projects.first.tasks.first), params: { format: :json }, headers: v1_headers

          expect(response.status).to eq 422
        end
      end
    end

    context 'when logged out' do
      it 'return 401: Unauthorized' do
        task = user.projects.first.tasks.first

        patch task_path(task), params: { format: :json }, headers: v1_headers

        expect(response.status).to eq 401
        expect(json).to include 'errors'
        expect(json).to_not include 'name'
      end
    end
  end

  describe '#destroy' do
    context 'when logged in' do
      it 'destroys user`s task' do
        task = user.projects.first.tasks.first

        auth_delete user, task_path(task), params: { format: :json }, headers: v1_headers

        expect(response.status).to eq 200
        expect(Task.exists?(task.id)).to be_falsey
      end

      it 'returns 404: Not Found if wrong id specified' do
        auth_delete user, task_path(-10), params: { format: :json }, headers: v1_headers

        expect(response.status).to eq 404
        expect(json).to include 'errors'
      end

      it 'does not allow destroying other user`s task' do
        other_task = other_user.projects.first.tasks.first

        auth_delete user, task_path(other_task), params: { format: :json }, headers: v1_headers

        expect(response.status).to eq 403
        expect(Task.exists?(other_task.id)).to be_truthy
      end
    end

    context 'when logged out' do
      it 'return 401: Unauthorized' do
        task = user.projects.first.tasks.first
        delete task_path(task), params: { format: :json }, headers: v1_headers

        expect(response.status).to eq 401
        expect(json).to include 'errors'
        expect(json).to_not include 'title'
      end
    end
  end

  describe '#finish' do
    context 'when logged in' do
      it 'finishes user`s task' do
        task = user.projects.first.tasks.first

        auth_patch user, finish_task_path(task), params: { format: :json }, headers: v1_headers

        expect(response.status).to eq 200
        expect(user.projects.first.tasks.first).to be_finished
      end

      it 'returns 404: Not Found if wrong id specified' do
        auth_patch user, finish_task_path(-10), params: { format: :json }, headers: v1_headers

        expect(response.status).to eq 404
        expect(json).to include 'errors'
      end

      it 'does not allow finishing other user`s task' do
        other_task = other_user.projects.first.tasks.first

        auth_patch user, finish_task_path(other_task), params: { format: :json }, headers: v1_headers

        expect(response.status).to eq 403
        expect(other_user.projects.first.tasks.first).to be_in_progess
      end
    end

    context 'when logged out' do
      it 'return 401: Unauthorized' do
        patch finish_task_path(user.projects.first.tasks.first), params: { format: :json }, headers: v1_headers

        expect(response.status).to eq 401
        expect(json).to include 'errors'
        expect(json).to_not include 'title'
      end
    end
  end

  describe '#to_progress' do
    context 'when logged in' do
      it 'finishes user`s task' do
        task = user.projects.first.tasks.first
        task.finish!

        auth_patch user, to_progress_task_path(task), params: { format: :json }, headers: v1_headers

        expect(response.status).to eq 200
        expect(user.projects.first.tasks.first).to be_in_progess
      end

      it 'returns 404: Not Found if wrong id specified' do
        auth_patch user, to_progress_task_path(-10), params: { format: :json }, headers: v1_headers

        expect(response.status).to eq 404
        expect(json).to include 'errors'
      end

      it 'does not allow finishing other user`s task' do
        other_task = other_user.projects.first.tasks.first
        other_task.finish!

        auth_patch user, to_progress_task_path(other_task), params: { format: :json }, headers: v1_headers

        expect(response.status).to eq 403
        expect(other_user.projects.first.tasks.first).to be_finished
      end
    end

    context 'when logged out' do
      it 'return 401: Unauthorized' do
        patch finish_task_path(user.projects.first.tasks.first), params: { format: :json }, headers: v1_headers

        expect(response.status).to eq 401
        expect(json).to include 'errors'
        expect(json).to_not include 'title'
      end
    end
  end
end
