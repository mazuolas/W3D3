class TagTopic < ActiveRecord::Base
  validates :tag_name, presence: true, uniqueness: true

  has_many :taggings,
    primary_key: :id,
    foreign_key: :topic_id,
    class_name: :Tagging

end
