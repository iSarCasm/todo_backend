module V1
  module JsonResponses
    def user_json
      {
        uid: :string,
        name: :string,
        email: :string,
        projects: :array_of_objects,
        avatar: :string
      }
    end

    def project_json
      {
        id: :integer,
        title: :string,
        desc: :string,
        tasks: :array_of_objects,
        in_active: :boolean
      }
    end

    def task_json
      {
        id: :integer,
        project_id: :integer,
        name: :string,
        desc: :string,
        deadline: :string,
        position: :integer,
        finished: :boolean,
        comments: :array_of_objects,
      }
    end

    def comment_json
      {
        id: :integer,
        task_id: :integer,
        user_name: :string,
        user_avatar: :string,
        content: :string,
        attachments: :array_of_strings
      }
    end

    def stats_json
      {
        users: :integer,
        projects: :integer,
        tasks: :integer,
        comments: :integer
      }
    end

    def shared_project_json
      {
        project_id: :integer,
        url: :string
      }
    end
  end
end
