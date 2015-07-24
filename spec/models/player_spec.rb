require 'rails_helper'

RSpec.describe Player, type: :model do
  before do
    create(:player, no: 55, position: 'G', name: '畑 享和',   born: '1990-03-17')
    create(:player, no: 5,  position: 'D', name: '今城 和智', born: '1987-03-11')
    create(:player, no: 14, position: 'F', name: '田中豪',    born: '1983-10-06')
  end

  describe "self.csv_all" do
    it "全データのCSVが戻る" do
      expect(Player.csv_all).to eq "\
ID,名前,守備,背番号,生年月日\r\n\
1,畑 享和,G,55,1990-03-17\r\n\
2,今城 和智,D,5,1987-03-11\r\n\
3,田中豪,F,14,1983-10-06\r\n".encode("Shift_JIS")
    end
  end

  describe "self.mege" do
  end
end


