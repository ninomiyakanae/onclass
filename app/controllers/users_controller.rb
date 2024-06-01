class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :edit_basic_info, :update_basic_info, :approvals_edit]
  before_action :logged_in_user, only: [:index, :show, :edit, :update, :destroy, :edit_basic_info, :update_basic_info]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: [:destroy, :edit_basic_info, :update_basic_info]
  before_action :set_one_month, only: [:show, :approvals_edit]
  before_action :admin_or_correct_user, only: :show

  
  def update
    if @user.update_attributes(user_params)
      flash[:success] = "ユーザー情報を更新しました。"
      redirect_to @user
    else
      render :edit
    end
  end






  def application_send
    # ここで@approval_listのインスタンスを設定します。
    @approval_list = Attendance.find(params[:id])

 
    # 上長が選択されているかをチェックします。
    if params[:attendance][:superior_id].blank?
      flash[:danger] = '上長を選択してください。'
      redirect_to user_path # 適切なパスに置き換えてください。
    else
      # 更新処理を行う
      if @approval_list.update(approval_params)
        flash[:success] =  "申請が更新されました。"
        redirect_to user_path(current_user, @approval_list) # 成功時のリダイレクト先は適宜設定してください。
      else
        render :user_path# エラーがある場合は編集ページを再表示
      end
    end
  end
  
  
  def index
    @users = User.paginate(page: params[:page], per_page: 10)
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
    if current_user.admin?
      redirect_to root_url
    else
      @attendance = Attendance.find(params[:id])
      @users = User.all
      @worked_sum = @attendances.where.not(started_at: nil).count
      @superiors = User.where(superior: true).where.not(id: @user.id)

      @notice_users = User.where(id: Attendance.where.not(schedule: nil).select(:user_id)).where.not(id: current_user)
      @notice_users.each do |user|
        # 何らかの処理
      end
  
      @attendances_list = Attendance.where.not(schedule: nil).where(overtime_check: false).where(confirmation: current_user.name)   
      @endtime_notice_sum = @attendances_list.count
      @attendances_list.each do |att_notice|
        @att_notice = att_notice  
      end
         
      @att_update_list = Attendance.where(attendance_change_check: false).where(attendance_change_flag: true).where(confirmation: current_user.name)   
      @att_update_sum = @att_update_list.count
      @att_update_list.each do |att_up|
        @att_up = att_up
      end
  
      @attendance = Attendance.find_by(worked_on: @first_day)
      @approval_list = Attendance.where(month: @first_day).where(user_id: current_user)
      @approval_list.each do |approval|
        @approval = approval
        @approval_superior = User.find_by(id: @approval.superior_id)
      end    
      if @applying_month
        if @applying_month.month_request_status != 'なし'
        @applying_month_superior = User.find_by(id: @applying_month.month_request_superior)
        @applying_month_count = Attendance.where(month_request_superior: current_user.id, month_request_status: '申請中').count
        else
          # @applying_monthが存在しない場合の処理をここに記述
          # 例えば、エラーメッセージを設定する、あるいは何もしない等
          flash[:alert] = '適用月のデータが存在しません。'
        end
      end       
    end    
  end     
  
  def approvals_edit
  end


  def edit_one_month
  end  
  


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
    
    # attendance パラメータの存在をチェック
    if params[:attendance].present?
      @attendance = Attendance.new(attendance_params)
      if @attendance.save
        redirect_to attendances_path, notice: '申請が完了しました。'
      else
        render :new
      end
    end
  end

  def edit

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
    
    

  def approval_params
    params.require(:attendance).permit(:confirmation_status)
  end

  def user_params
    params.require(:user).permit(:name, :email, :affiliation, :password, :password_confirmation)
  end

  def basic_info_params
    params.require(:user).permit(:name, :email, :affiliation, :employee_number, :uid, :password, :basic_work_time, :designated_work_start_time, :designated_work_end_time)
  end

  # フォームから送信されるパラメータの安全な処理
  def attendance_params
    # 必要なパラメータを許可
    params.require(:attendance).permit(:superior_id, :worked_on, :confirmation_status)
  end
end
