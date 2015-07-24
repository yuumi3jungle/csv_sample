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

  describe "self.import" do
    it "csv文字列を受け取り、そのデータでPlayerインスタンスの配列を作る" do
      csv = "ID,名前,守備,背番号,生年月日\r\n1,畑 享和,G,55,1990-03-17\r\n,今城 和智,D,5,1987-03-11\r\n".encode("Shift_JIS")
      players, errors = Player.import(csv)

      expect(errors.any?).to be_falsy
      expect(players.size).to eq 2
      expect(players[0].attributes.values_at(*Player::CSV_COLUMNS)).to eq(
        [1, "畑 享和", "G", 55, "1990-03-17".to_date])
      expect(players[1].attributes.values_at(*Player::CSV_COLUMNS)).to eq(
        [nil, "今城 和智", "D", 5, "1987-03-11".to_date])
    end
    it "csv文字列に間違いがあればerrorsを戻す" do
      csv = "ID,名前,守備,背番号,生年月日\r\n1,畑 享和,X,5a,1990-03-17\r\n2,,D,5,1987-03-11\r\n".encode("Shift_JIS")
      players, errors = Player.import(csv)
      expect(errors).to eq ["2行目: 背番号は数値で入力してください, 守備は一覧にありません", "3行目: 名前を入力してください"]
    end
  end

  describe "self.merge" do
    it "IDの無いデータはデーブルに追加される" do
      errors = Player.merge([Player.new(no: 47, position: 'F', name: '篠原 亨太',   born: '1984-03-28')])

      expect(errors.any?).to be_falsy
      expect(Player.last.name).to eq "篠原 亨太"
    end
    it "IDのあるデータはデーブルの旧データを更新する" do
      player = Player.first
      player.no = 56
      errors = Player.merge([player])

      expect(errors.any?).to be_falsy
      expect(Player.first.no).to eq 56
    end
    it "IDはあるデータに対しデーブルに旧データが無ければエラー" do
      player = Player.last
      player.id = player.id + 1
      errors = Player.merge([player])

      expect(errors.count).to eq 1
      expect(errors[0]).to match /データは存在しません/
    end
  end

end


