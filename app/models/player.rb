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

  def self.import(raw_csv_string, skip_first_line = true)
    csv_string = raw_csv_string.force_encoding("Shift_JIS").encode("UTF-8")
    csv_array = CSV.parse(csv_string)

    players = []
    errors = []
    line = 1
    if skip_first_line
      csv_array.shift()
      line = 2
    end

    csv_array.each do |csv|
      player = Player.new(Hash[CSV_COLUMNS.zip(csv)])
      if player.valid?
        players << player
      else
        errors << "#{line}行目: #{player.errors.full_messages.join(', ')}"
      end
      line += 1
    end

    [players, errors]
  end

  def self.merge(players)
    errors = []

    players.each do |player|
      if player.id
        p = Player.find_by(id: player.id)
        if p
          p.update(Hash[CSV_COLUMNS.zip(player.attributes.values_at(*CSV_COLUMNS))])
        else
          errors << "id = #{player.id} データは存在しません"
        end
      else
        player.save
      end
    end
    errors
  end
end
