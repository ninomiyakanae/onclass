class Attendance < ApplicationRecord
  belongs_to :user
  # belongs_to :applied_user, class_name: 'User', foreign_key: 'applied_user_id'

  validates :worked_on, presence: true
  validates :note, length: { maximum: 50 }
  # validates :superior_id, presence: { message: '上長を選択してください' }
  enum confirmation_status: { なし: 0, 申請中: 1, 承認: 2, 否認: 3 }
  


  # 出勤時間が存在しない場合、退勤時間は無効
  # validate :designated_work_end_time_is_invalid_without_a_designated_work_start_time
  # 出勤・退勤時間どちらも存在する時、出勤時間より早い退勤時間は無効
  # validate :designated_work_start_time_than_designated_work_end_time_fast_if_invalid

  # def designated_work_end_time_is_invalid_without_a_designated_work_start_time
  #   errors.add(:designated_work_start_time, "が必要です") if designated_work_start_time.blank? && designated_work_end_time.present?
  # end

  # def designated_work_start_time_than_designated_work_end_time_fast_if_invalid
  #   if designated_work_start_time.present? && designated_work_end_time.present?
  #     errors.add(:designated_work_start_time, "より早い退勤時間は無効です") if designated_work_start_time > designated_work_end_time
  #   end
  # end
end