class Link < ActiveRecord::Base
  #belongs_to :collection, touch: true

  validates :url, presence: true
end
