module AttendancesHelper

  def attendance_state(attendance)
    # 受け取ったAttendanceオブジェクトが当日と一致するか評価します。
    if Date.current == attendance.worked_on
      return '出勤' if attendance.designated_work_start_time.nil?
      return '退勤' if attendance.designated_work_start_time.present? && attendance.designated_work_end_time.nil?
    end
    # どれにも当てはまらなかった場合はfalseを返します。
    return false
  end

  # 出勤時間と退勤時間を受け取り、在社時間を計算して返します。
  def working_times(start, finish)
    format("%.2f", (((finish - start) / 60) / 60.0))
    # sprintf("%.2f", (((finish - start) / 60) / 60.0))
  end
  
  def convert_basic_time_to_number(basic_work_time)
    # ここでbasic_time（例："8:00"）を数値（例：8.0）に変換する処理
    # 今回は既に数値形式（例：8.0）であると仮定
   basic_work_time.to_f
  end
  

  # 出勤時間と退勤時間を受け取り、在社時間を計算して返します。
#   def times(start, finish)
#     format("%.2f", (((finish - start) / 60) / 60.0))
#   end
  
#   def format_min(time)
#     format("%.2d",((time.strftime('%M').to_i / 15).round)* 15)
      
#   end
  
#   def working_times(start, finish)
#     format("%.2f", (((finish - start) / 60) / 60.0))
#   end


#   def working_overtimes(start, finish)
#     format("%.2f", (((finish - start) / 60) / 60.0)-(60.0*8))
#   end
# end
  
  
  # class Time
  #   def floor_to(seconds)
  #     Time.at((self.to_f / seconds).floor * seconds)
  #   end
  # end
end