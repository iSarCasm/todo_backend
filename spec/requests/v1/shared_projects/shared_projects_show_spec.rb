require 'rails_helper'

RSpec.describe "Shared Projects Show API", type: :request do
  let!(:user) { FactoryGirl.create :user }
  let!(:project) { FactoryGirl.create :project, user: user }
  let!(:shared_project) { FactoryGirl.create :shared_project, project: project }

  it 'allows to view project through shared url to anyone' do
    v1_get shared_project_path(shared_project.project)

    expect(response.status).to eq 200
    expect_json_types shared_project_json
  end

  it 'project still not reachable without shared link' do
    v1_get project_path(shared_project.project)

    expect_http_error 401
  end
end
