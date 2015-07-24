require 'csv'

class Player < ActiveRecord::Base
  validates_presence_of :name
  validates_numericality_of :no, allow_blank: true
  validates_inclusion_of :position, in: %w(G D F), allow_blank: true
  validates_format_of :born, with: /\A\d{4}-\d{1,2}-\d{1,2}\z/, allow_blank: true

  CSV_COLUMNS = %w(id name position no born)

  def self.csv_all
    csv = CSV_COLUMNS.map{|c| I18n.t "activerecord.attributes.player.#{c}"}.to_csv

    self.order(:id).each do |e|
      values = e.attributes.values_at(*CSV_COLUMNS)
      csv << values.to_csv
    end

    csv.gsub("\n", "\r\n").encode("Shift_JIS")
  end

end
