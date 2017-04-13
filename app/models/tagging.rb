class Tagging < ActiveRecord::Base
  validates :topic_id, :shortened_url_id, presence: true

  belongs_to :tag_topics,
    primary_key: :id,
    foreign_key: :topic_id,
    class_name: :TagTopic

  belongs_to :shortened_url,
    primary_key: :id,
    foreign_key: :shortened_url_id,
    class_name: :ShortenedUrl

end
