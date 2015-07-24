class Player < ActiveRecord::Base
  validates_presence_of :name
  validates_numericality_of :no, allow_blank: true
  validates_inclusion_of :position, in: %w(G D F), allow_blank: true
  validates_format_of :born, with: /\A\d{4}-\d{1,2}-\d{1,2}\z/, allow_blank: true
end
