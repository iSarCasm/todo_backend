module V1
  module JsonResponses
    def user_json
      {
        uid: :string,
        name: :string,
        email: :string,
        projects: :array_of_objects
      }
    end

    def project_json
      {
        title: :string,
        desc: :string,
        tasks: :array_of_objects,
        in_active: :boolean
      }
    end

    def task_json
      {
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
        content: :string
      }
    end
  end
end
