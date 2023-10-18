class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :edit_basic_info, :update_basic_info]
  before_action :logged_in_user, only: [:index, :show, :edit, :update, :destroy, :edit_basic_info, :update_basic_info]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: [:destroy, :edit_basic_info, :update_basic_info]
  before_action :set_one_month, only: :show
  before_action :admin_or_correct_user, only: :show
  # before_action :superior_user, only: :show  
  
  
  def index
    @users = User.paginate(page: params[:page], per_page: 10)
    # respond_to do |format|
    #   format.html # HTML形式のレスポンスを処理
    #   format.csv { send_data @users.to_csv, filename: "users-#{Date.today}.csv" } # CSV形式のレスポンスを処理
  end
    # @user = current_user # これがログイン中のユーザーを取得するメソッドであれば

  def index
    @users = User.where.not(id: 1).paginate(page: params[:page]).search(params[:search])
    # @users = User.all
  end

  
  def import
    failed_emails = User.import(params[:file])
  
    if failed_emails.empty?
      flash[:success] = 'インポートに成功しました。'
    else
      flash[:danger] = "メールアドレス #{failed_emails.join(', ')} はすでに存在します。"
    end
    
    redirect_to users_path
  end

  def show
    @worked_sum = @attendances.where.not(designated_work_start_time: nil).count
  end
  
# def show
#     if current_user.admin?
#       redirect_to root_url
#     else
#       @attendance = Attendance.find(params[:id])
#       @worked_sum = @attendances.where.not(started_at: nil).count
#       @superior = User.where(superior: true).where.not(id: @user.id)
#       # 残業申請のお知らせボタン
#       @notice_users = User.where(id: Attendance.where.not(schedule: nil).select(:user_id)).where.not(id: current_user)
#       @notice_users.each do |user|
#         @attendances_list = Attendance.where.not(schedule: nil).where(overtime_check: false).where(confirmation: current_user.name)
#         @endtime_notice_sum = @attendances_list.count
#         @attendances_list.each do |att_notice|
#           @att_notice = att_notice
#         end
#     end
#       # 所属長承認申請お知らせリスト(上長)
#     @approval_notice_lists = Approval.where(confirm: "申請中").where(approval_flag: false).where(superior_id: current_user)
#     @approval_notice_lists.each do |app|
#       @superior_approval = app
#     end
#       # 所属長承認申請合計
#     @approval_notice_sum = @approval_notice_lists.count

#       # if current_user.superior?
#       #   @overwork_sum = Attendance.includes(:user).where(superior_confirmation: current_user.id,overwork_status:　"申請中").count
#       # end
#     end
# end  

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = '新規作成に成功しました。'
      redirect_to @user
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "ユーザー情報を更新しました。"
      redirect_to @user
    else
      render :edit      
    end
  end

  def destroy
    @user.destroy
    flash[:success] = "#{@user.name}のデータを削除しました。"
    redirect_to users_url
  end

  def edit_basic_info
  end

  def update_basic_info
    if @user.update_attributes(basic_info_params)
      flash[:success] = "#{@user.name}の基本情報を更新しました。"
    else
      flash[:danger] = "#{@user.name}の更新は失敗しました。<br>" + @user.errors.full_messages.join("<br>")
    end
    redirect_to users_url
  end
  
  private

    def user_params
      params.require(:user).permit(:name, :email, :affiliation, :password, :password_confirmation)
    end

    def basic_info_params
      params.require(:user).permit(:name, :email, :affiliation, :employee_number, :uid, :password, :basic_work_time, :designated_work_start_time, :designated_work_end_time)
    end
    
    # def overwork_request_params
    #   params.permit(:tomorrow_check, :next_day, :work_process, :superior)
    # end    
end
