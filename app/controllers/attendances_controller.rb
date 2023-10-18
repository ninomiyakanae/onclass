class AttendancesController < ApplicationController
  before_action :set_user, only: [:edit_one_month, :update_one_month]
  before_action :logged_in_user, only: [:update, :edit_one_month]
  before_action :admin_or_correct_user, only: [:update, :update_one_month, :edit_one_month]
  before_action :set_one_month, only: :edit_one_month
  # before_action :superior_user, only: [:edit_overtime_info, :edit_change_attendance]

  UPDATE_ERROR_MSG = "勤怠登録に失敗しました。やり直してください。"
  
  def working
    @attendances = Attendance.where(worked_on: Date.current).where.not(designated_work_start_time: nil).where(designated_work_end_time: nil)
    @users = User.all.includes(:attendances)
    
    @users.each do |user|
      user.employee_number = (user.id * 111).to_s
      user.save
    end
  end  
  

# def set_employee_number
#   self.employee_number = (id * 111).to_s  # IDに100を掛けて文字列に変換して設定
#   save
# end  

  def update
    @user = User.find(params[:user_id])
    @attendance = Attendance.find(params[:id])
    # 出勤時間が未登録であることを判定します。
    if @attendance.designated_work_start_time.nil?
      if @attendance.update_attributes(designated_work_start_time: Time.current.floor_to(15.minutes).change(sec: 0)) 
        flash[:info] = "おはようございます！"
      else
        flash[:danger] = UPDATE_ERROR_MSG
      end
    elsif @attendance.designated_work_end_time.nil?
      if @attendance.update_attributes(designated_work_end_time: Time.current.floor_to(15.minutes).change(sec: 0))  
        flash[:info] = "お疲れ様でした。"
      else
        flash[:danger] = UPDATE_ERROR_MSG
      end
    end
    redirect_to @user
  end
    
  def show
  end

  

  def edit_one_month
  end


  def update_one_month
      ActiveRecord::Base.transaction do
        attendances_params.each do |id, item|
          if item[:designated_work_start_time].present? && item[:designated_work_end_time].blank?
            flash[:danger] = "退勤も更新してください"
            redirect_to attendances_edit_one_month_user_url(date: params[:date])and return
          end  

            attendance = Attendance.find(id)
            attendance.update_attributes!(item)
        end
      end
      # flash[:success] = "1ヶ月分の勤怠情報を更新しました。"
      redirect_to user_url(date: params[:date])and return
  rescue ActiveRecord::RecordInvalid
      flash[:danger] = "無効な入力データがあった為、更新をキャンセルしました。"
      redirect_to attendances_edit_one_month_user_url(date: params[:date])
  end


  private

    # 1ヶ月分の勤怠情報を扱います。
  def attendances_params
    params.require(:user).permit(attendances: [:designated_work_start_time, :designated_work_end_time, :note])[:attendances]
  end

  # def updated_time_params
  #   params.require(:user).permit(attendances: [:designated_work_start_time, :designated_work_end_time, :tommorow_check, :note, :name])[:attendances]
  # end
    # beforeフィルター


    # 管理権限者、または現在ログインしているユーザーを許可します。
  def admin_or_correct_user
    @user = User.find(params[:user_id]) if @user.blank?
    unless current_user == @user || current_user.admin?
      flash[:danger] = "編集権限がありません。"
      redirect_to(root_url)
    end  
  end
end