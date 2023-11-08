class Approval < ApplicationRecord
    # 上長のIDが選択されていることを確認するバリデーション
  validates :superior_id, presence: { message: '上長を選択してください' }
end
