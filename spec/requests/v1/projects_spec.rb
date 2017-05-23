require 'rails_helper'

RSpec.describe "Projects API", type: :request do
  let(:user) { FactoryGirl.create(:user_with_projects) }
  let(:other_user) { FactoryGirl.create(:user_with_projects) }

  describe '#show' do
    context 'when logged in' do
      it 'returns the project with list of tasks' do
        v1_auth_get user, project_path(user.projects.first)

        expect(response.status).to eq 200
        expect_json_types(
          title: :string,
          tasks: :array_of_objects
        )
        expect_json_types(
          'tasks.*',
          name: :string,
          desc: :string,
          deadline: :string,
          comments: :array_of_objects,
          finished: :boolean,
        )
        expect_json_types(
          'tasks.*.comments.*',
          content: :string,
        )
      end

      it 'returns 404: Not Found when accessing others project' do
        v1_auth_get user, project_path(other_user.projects.first)
        expect_http_error 404
      end
    end

    context 'when logged out' do
      it 'return 401: Unauthorized' do
        v1_get project_path(user.projects.first)
        expect_http_error 401
      end
    end
  end

  describe '#create' do
    context 'when logged in' do
      context 'with valid params' do
        it 'creates a new project' do
          project_params = { title: "New project", desc: "Some long desc" }
          v1_auth_post user, projects_path, params: { project: project_params }

          expect(response.status).to eq 200
          expect_json(title: "New project", desc: "Some long desc")
        end
      end

      context 'with invalid params' do
        it 'fails to create a new project' do
          v1_auth_post user, projects_path
          expect_http_error 422
        end
      end
    end

    context 'when logged out' do
      it 'return 401: Unauthorized' do
        v1_post projects_path
        expect_http_error 401
      end
    end
  end

  describe '#update' do
    context 'when logged in' do
      context 'with valid params' do
        before do
          @project_params = { desc: "New long desc" }
        end

        it 'updates' do
          v1_auth_patch user, project_path(user.projects.first), params: { project: @project_params }

          expect(response.status).to eq 200
          expect_json(desc: "New long desc")
          expect_json_types(title: :string, desc: :string)
        end

        context 'editing other user`s project' do
          it 'returns 404: Not Found when accessing others project' do
            v1_auth_patch user, project_path(other_user.projects.first), params: { project: @project_params }
            expect_http_error 404
          end
        end
      end

      context 'with invalid params' do
        it 'fails to update the project' do
          v1_auth_patch user, project_path(user.projects.first)
          expect_http_error 422
        end
      end
    end

    context 'when logged out' do
      it 'return 401: Unauthorized' do
        v1_patch project_path(user.projects.first)
        expect_http_error 401
      end
    end
  end

  describe '#destroy' do
    context 'when logged in' do
      it 'destroys user`s project' do
        project = user.projects.first
        v1_auth_delete user, project_path(project)

        expect(response.status).to eq 200
        expect(Project.exists?(project.id)).to be_falsey
      end

      it 'does not allow destroying other user`s project' do
        other_project = other_user.projects.first
        v1_auth_delete user, project_path(other_project)

        expect_http_error 404
        expect(Project.exists?(other_project.id)).to be_truthy
      end
    end

    context 'when logged out' do
      it 'return 401: Unauthorized' do
        v1_delete project_path(user.projects.first)
        expect_http_error 401
      end
    end
  end

  describe '#archive' do
    context 'when logged in' do
      it 'archives user`s project' do
        project = user.projects.first

        v1_auth_patch user, archive_project_path(project)

        expect(response.status).to eq 200
        expect(user.projects.first).to be_in_acrhived
      end

      it 'does not allow archiving other user`s project' do
        other_project = other_user.projects.first

        v1_auth_patch user, archive_project_path(other_project)

        expect_http_error 404
        expect(other_user.projects.first).to be_in_active
      end
    end

    context 'when logged out' do
      it 'return 401: Unauthorized' do
        v1_patch archive_project_path(user.projects.first)
        expect_http_error 401
      end
    end
  end

  describe '#to_progress' do
    context 'when logged in' do
      it 'activates user`s project' do
        project = user.projects.first
        project.archive!

        v1_auth_patch user, activate_project_path(project)

        expect(response.status).to eq 200
        expect(user.projects.first).to be_in_active
      end

      it 'does not allow activatin other user`s project' do
        other_project = other_user.projects.first
        other_project.archive!

        v1_auth_patch user, activate_project_path(other_project)

        expect_http_error 404
        expect(other_user.projects.first).to be_in_acrhived
      end
    end

    context 'when logged out' do
      it 'return 401: Unauthorized' do
        v1_patch activate_project_path(user.projects.first)
        expect_http_error 401
      end
    end
  end
end
