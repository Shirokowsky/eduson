class Collection < ActiveRecord::Base
  has_many :photos, as: :linkable, dependent: :destroy
  has_many :links, as: :linkable, dependent: :destroy

  accepts_nested_attributes_for :photos, allow_destroy: true
  accepts_nested_attributes_for :links, allow_destroy: true

  validates :title, :description, presence: true

  default_scope { order(created_at: :desc) }
end
