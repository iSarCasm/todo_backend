require 'rails_helper'

RSpec.describe "Shared Projects Create API", type: :request do
  let(:user) { FactoryGirl.create :user }
  let(:project) { FactoryGirl.create :project, user: user }
  let(:other_project) { FactoryGirl.create :project }

  it 'doesnt allow creating shared projects for visitors' do
    v1_post shared_projects_path, params: { project_id: project.id }
    expect_http_error 401
  end

  it 'doesnt allow creating shared projects for other`s project' do
    v1_auth_post user, shared_projects_path, params: { project_id: other_project.id }
    expect_http_error 404
  end

  it 'doesnt allow more than one shared project per user project' do
    FactoryGirl.create :shared_project, project: project

    v1_auth_post user, shared_projects_path, params: { project_id: project.id }

    expect_http_error 422
  end

  it 'can successfuly create shared project' do
    v1_auth_post user, shared_projects_path, params: { project_id: project.id }

    expect(response.status).to eq 200
    expect_json_types shared_project_json
  end
end
