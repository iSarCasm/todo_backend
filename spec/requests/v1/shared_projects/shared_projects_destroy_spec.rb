require 'rails_helper'

RSpec.describe "Shared Projects Destroy API", type: :request do
  let(:user) { FactoryGirl.create :user }
  let(:project) { FactoryGirl.create :project, user: user }
  let(:shared_project) { FactoryGirl.create :shared_project, project: project }
  let(:other_shared_project) { FactoryGirl.create :shared_project }

  it 'doesnt allow destroying shared projects for visitors' do
    v1_delete shared_project_path(shared_project.project)
    expect_http_error 401
  end

  it 'doesnt allow destroying shared projects for other`s project' do
    v1_auth_delete user, shared_project_path(other_shared_project.project)
    expect_http_error 404
  end

  it 'can successfuly destroy shared project (make private again)' do
    v1_auth_delete user, shared_project_path(shared_project.project)

    expect(SharedProject.exists?(shared_project.id)).to be_falsey
    expect(response.status).to eq 200
    expect_json_types shared_project_json
  end
end
