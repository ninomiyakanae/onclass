class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :edit_basic_info, :update_basic_info, :approvals_edit]
  before_action :logged_in_user, only: [:index, :show, :edit, :update, :destroy, :edit_basic_info, :update_basic_info]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: [:destroy, :edit_basic_info, :update_basic_info]
  before_action :set_one_month, only: [:show, :approvals_edit]
  before_action :admin_or_correct_user, only: :show
  # before_action :superior_user, only: [:edit_one_month, :update_one_month]
  # before_action :set_approval_list, only: [:update_one_month]

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "ユーザー情報を更新しました。"
      redirect_to @user
    else
      render :edit
    end
    
    # @approval = Approval.find(params[:id])
    # if @approval.update(approval_params)
    #   # 更新に成功した場合の処理
    #   flash[:success] =  "申請が更新されました。"
    #   redirect_to user_path
    # else
    #   # エラーがある場合の処理
    #   render :user_path
    # end
  end


  def application_send
    # ここで@approval_listのインスタンスを設定します。
    @approval_list = Attendance.find(params[:id])
  #   @approval_list = Approval.find_by(id: params[:id])
    
  # # 申請中の件数を計算します。
  # @approval_notice_lists = Approval.where(confirm: "申請中", approval_flag: false, superior_id: current_user)
  # @approval_notice_sum = @approval_notice_lists.count    

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
  
  # def application_send
  #   # @approval_listを適切に初期化する
  #   @approval_list = Approval.find_by(id: params[:id]) # または別の適切な検索条件を使用

  #   if @approval_list.nil?
  #     # @approval_listがnilの場合、エラーメッセージを表示するなどの処理
  #     flash[:error] = "承認申請が見つかりません。"
  #     redirect_to user_path # 適切なパスにリダイレクト
  #   else
  #     # 以下のコードはそのまま
  #     if @approval_list.update(approval_params)
  #       flash[:success] = "申請が更新されました。"
  #       redirect_to user_path(current_user, @approval_list)
  #     else
  #       # 更新に失敗した場合の処理
  #     end
  #   end
  # end 
  
  def index
    @users = User.paginate(page: params[:page], per_page: 10)
    # respond_to do |format|
    #   format.html # HTML形式のレスポンスを処理
    #   format.csv { send_data @users.to_csv, filename: "users-#{Date.today}.csv" } # CSV形式のレスポンスを処理
  end
    # @user = current_user # これがログイン中のユーザーを取得するメソッドであれば

  # def index
  #   @users = User.where.not(id: 1).paginate(page: params[:page]).search(params[:search])
  #   # @users = User.all
  # end

  
  def import
    failed_emails = User.import(params[:file])
  
    if failed_emails.empty?
      flash[:success] = 'インポートに成功しました。'
    else
      flash[:danger] = "メールアドレス #{failed_emails.join(', ')} はすでに存在します。"
    end
    
    redirect_to users_path
  end

  # def show
  #   @worked_sum = @attendances.where.not(designated_work_start_time: nil).count
  # end
    
 
  
  def show
    if current_user.admin?
      redirect_to root_url
    else
      @attendance = Attendance.find(params[:id])
      @worked_sum = @attendances.where.not(designated_work_start_time: nil).count
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
  
      @approval_notice_lists = Attendance.where(confirmation_status: "申請中").where(confirmation_status: false).where(superior_id: current_user)
      @approval_notice_lists.each do |app|
        @superior_approval = app
      end
      @approval_notice_sum = @approval_notice_lists.count   
      # @approval_notice_sum = Approval.includes(:user).where(superior_month_notice_confirmation: current_user.id, confirmation_status: "申請中").count
    end        
    # @approval_notice_sum = Approval.includes(:user).where(superior_month_notice_confirmation: current_user.id, confirmation_status: "申請中").count    
    #   end
    #   @approval_notice_lists = Approval.where(confirmation_status: 1).where(confirmation_status: false).where(superior_id: current_user)
    #   @approval_notice_lists.each do |app|
    #     @superior_approval = app
    #   end
    #   @approval_notice_sum = @approval_notice_lists.count   
    # end    
  end       
  



      
  def approvals_edit
    # @month_attendances = Attendance.where(superior_month_notice_confirmation: @user.id, confirmation_status: "申請中").order(:user_id, :worked_on).group_by(&:user_id) 

    # @users = User.find(params[:id])
    # @users = User.find(params[:id])
    # if @approval.update(approval_params)
    #   if @approval.status_applying
    #     # "申請中" の件数をカウント
    #     @pending_approvals_count = Approval.where(confirmation_status: 1).count
    #     # 件数をフラッシュメッセージに設定
    #     flash[:notice] = "申請中の件数: #{@pending_approvals_count}"
    #   end
    #   redirect_to user_path # 成功時のリダイレクト先
    # else
    #   render :edit # 失敗時の処理
    # end
    # @attendance = Attendance.find(params[:id])
    # status = params[:attendance][:monthly_confirmation_status].to_i

    # case status
    # when 1 # 申請中
    #   # 上司に申請して、まだ承認または非承認されていない状態を処理
    #   @attendance.update(monthly_confirmation_status: "申請中")
    #   flash[:info] = "上司に申請が送信されました。"
    # when 2 # 承認
    #   # 上司が申請を承認した場合の処理
    #   @attendance.update(monthly_confirmation_status: "承認")
    #   flash[:success] = "申請が承認されました。"
    # when 3 # 非承認
    #   # 上司が申請を否認した場合の処理
    #   @attendance.update(monthly_confirmation_status: "非認")
    #   flash[:danger] = "申請が非承認されました。"
    # else
    #   # それ以外の処理（例えば、申請なしの場合）
    #   flash[:warning] = "申請のステータスが正しくありません。"
    # end

    # redirect_to attendances_path # 適切なリダイレクト先に変更してください
  end

#     @attendances = Attendance.where(user_id: current_user.id)
  
#     # @userを定義します。ここでは現在のユーザーを指定しています。
#     @user = current_user
  
#     @approval_list = Attendance.where(confirmation: "申請中", applied_user_id: @user.id)
  
#     # params[:user]が存在する場合のみ、以下の処理を行う
#     if params[:user] && params[:user][:month_approval]
#       # 特定のユーザーのattendancesから、送られてきた日付の勤怠データを取得
#       @attendance = @user.attendances.find_by(worked_on: params[:user][:month_approval])
  
#       # @attendanceが存在する場合のみ、以下の処理を行う
#       if @attendance
#         # @attendanceのmonth_approval属性を日付形式に変換
#         @mon = Date.parse(@attendance.month_approval)
    
#   # @attendances = Attendance.where(user_id: current_user.id)
#   # @approval_list = Attendance.where(confirmation: "申請中", applied_user_id: @user.id)

#   # # params[:user]が存在する場合のみ、以下の処理を行う
#   # if params[:user] && params[:user][:month_approval]
#   #   # 特定のユーザーのattendancesから、送られてきた日付の勤怠データを取得
#   #   @attendance = @user.attendances.find_by(worked_on: params[:user][:month_approval])

#   #   # @attendanceが存在する場合のみ、以下の処理を行う
#   #   if @attendance
#   #     # @attendanceのmonth_approval属性を日付形式に変換
#   #     @mon = Date.strptime(@attendance.month_approval, month_names: :middle)

#       # 送られてきたパラメータを使用して、@attendanceを更新
#       # 成功した場合、flashメッセージで成功を知らせる
#       # if @attendance.update_attributes(month_approval_params)
#       #   flash[:success] = "#{mon}月の勤怠承認申請を受け付けました"
#       # end
      
# #         # @attendanceのmonth_approval属性を日付形式に変換
# # @mon = Date.strptime(@attendance.month_approval)


#       # ユーザーの詳細ページにリダイレクト
#       redirect_to user_url(@user)
#     end
#   else
#     # params[:user]またはparams[:user][:month_approval]が存在しない場合の処理
#     # 必要に応じて、ここにエラーメッセージの表示やその他の処理を追加できます。
#   end
  # end
  
  
  
  
  # @user = User.find(params[:id])
  
  # if @user.update(attendance_params)
  #   # 成功時の処理、例えばリダイレクトや成功メッセージの表示など
  #   redirect_to some_path, notice: 'Attendances were successfully updated.'
  # else
  #   # 失敗時の処理、例えばエラーメッセージの表示や編集ページに戻るなど
  #   render :edit
  # end
    # @first_day = Approval.where(confirm: "申請中").where(superior_id: current_user)
  # 申請中のApprovalを全て取得
  # @approvals_pending = Approval.where(confirm: "申請中")

  # # それに対応するAttendanceのIDを取得
  # @attendance = @approvals_pending.pluck(:attendance_id)

  # # そのIDに対応するAttendanceを取得
  # @attendances = Attendance.where(id: attendance_ids)    
    # URLから日付を取得、もしなければ現在の月の初日を取得
    # @first_day = params[:date].nil? ? Date.current.beginning_of_month : Date.parse(params[:date])
    # @attendances_for_user = Attendance.find(params[:id])
    # @pending = Attendance.find(params[:id])

  # def show
  #   if current_user.admin?
  #     redirect_to root_url
  #   else
  #     @attendance = Attendance.find(params[:id])
  #     @worked_sum = @attendances.where.not(designated_work_start_time: nil).count
  #     @superiors = User.where(superior: true).where.not(id: @user.id)
  
  #     @notice_users = User.where(id: Attendance.where.not(schedule: nil).select(:user_id)).where.not(id: current_user)
  #     @notice_users.each do |user|
  #       # 何らかの処理
  #     end
  
  #     @attendances_list = Attendance.where.not(schedule: nil).where(overtime_check: false).where(confirmation: current_user.name)   
  #     @endtime_notice_sum = @attendances_list.count
  #     @attendances_list.each do |att_notice|
  #       @att_notice = att_notice  
  #     end
         
  #     @att_update_list = Attendance.where(attendance_change_check: false).where(attendance_change_flag: true).where(confirmation: current_user.name)   
  #     @att_update_sum = @att_update_list.count
  #     @att_update_list.each do |att_up|
  #       @att_up = att_up
  #     end
  
  #     @attendance = Attendance.find_by(worked_on: @first_day)
  #     @approval_list = Approval.where(month_at: @first_day).where(user_id: current_user)
  #     @approval_list.each do |approval|
  #       @approval = approval
  #       @approval_superior = User.find_by(id: @approval.superior_id)
  #     end    
        
  #     @approval_notice_lists = Approval.where(confirm: "申請中").where(approval_flag: false).where(superior_id: current_user)
  #     @approval_notice_lists.each do |app|
  #       @superior_approval = app
  #     end
        
  #     @approval_notice_sum = @approval_notice_lists.count   
  #   end    
  # end      
      # @superiors = User.where(superior: true).where.not(id: @user.id)
    
      # # 以下は例えばです。実際の保存処理に合わせてください。
      # if params[:approval_list].present?
      #   @approval_list.assign_attributes(params[:id])# ここは実際のパラメータに置き換えてください
      #   if @approval_list.save
      #     @text_color = 'color: red;'
      #     flash[:success] = '申請が完了しました'
      #   else
      #     flash[:error] = '申請に失敗しました'
      #   end
      # else
      #   @text_color = ''
        # flash[:error] = '上長を指定してください。'
        
          # redirect_to approvals_edit_user_path(current_user)
      # end
      
          # @user = User.find(params[:id])

      # 画面をリダイレクトかレンダリングして終了
      # if params[:superior_id].present? && @superiors.map(&:id).include?(params[:superior_id].to_i)
      #   # 申請の処理
      #   @text_color = 'color: red;'
      # else
      #   @text_color = ''
      #   flash[:error] = '上長を指定してください。'
      # end      
      # @text_color = @approval_notice_sum > 0 ? 'color:red;' : ''
    #   @text_color = if @approval_notice_sum > 0
    #                   'color:red;'
    #                 else
    #                   'color:black;'
    #                 end      
    # @color_change_condition = true                

  
  def edit_one_month
  end  
  
  # def update_one_month
  #   # ここで@approval_listのインスタンスを設定します。
  #   @approval_list = Approval.find(params[:id])

  #   # 上長が選択されているかをチェックします。
  #   if params[:approval][:superior_id].blank?
  #     flash[:danger] = '上長を選択してください。'
  #     redirect_to user_path # 適切なパスに置き換えてください。
  #   else
  #     # 更新処理を行う
  #     if @approval_list.update(approval_params)
  #       flash[:success] = '申請が更新されました。'
  #       redirect_to approvals_edit_user_path(current_user, @approval_list) # 成功時のリダイレクト先は適宜設定してください。
  #     else
  #       render :user_path# エラーがある場合は編集ページを再表示
  #     end
  #   end
  # end


  # @attendance = Attendance.find(params[:id])

  # # 上長ユーザが選択されているかチェック
  # if params[:attendance][:confirmation].blank?
  #   @attendance.errors.add(:confirmation, "上長を選択してください")
  #   # ビューでエラーメッセージを表示できるようにします。
  #   render 'edit'
  # else
  #   # 上長ユーザが選択されている場合は更新処理
  #   if @attendance.update(attendance_params)
  #     flash[:success] = "申請しました。"
  #     redirect_to user_url(date: params[:date])
  #   else
  #     render 'edit'
  #   end
  # end

  #   c1 = 0
  #   ActiveRecord::Base.transaction do # トランザクションを開始します。
  #     attendances_params.each do |id, item|
  #       attendance = Attendance.find(id) # Attendanceテーブルから1つのidを見つける
  #       if item[:overwork_request_superior].present?
  #         item[:overwork_request_status] = "申請中"
  #       elsif item[:daily_request_superior].present?
  #         item[:daily_request_status] = "申請中"
  #       else item[:monthly_request_superior].present?
  #         item[:monthly_request_status] = "申請中"  
  #         c1 += 1
  #         attendance.update_attributes!(item)
  #       end
  #     end
  #   end
  #   if c1 > 0
  #     flash[:success] = "勤怠編集を#{c1}件、申請しました。"
  #     redirect_to user_url(date: params[:date])
  #   else
  #     flash[:danger] = "上長を選択してください"
  #     redirect_to attendances_edit_one_month_user_url(date: params[:date])
  #   end
  # rescue ActiveRecord::RecordInvalid # トランザクションによるエラーの分岐です。
  #   flash[:danger] = "無効な入力データがあった為、更新をキャンセルしました。"
  #   redirect_to attendances_edit_one_month_user_url(date: params[:date])


  

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
    
    @attendance = Attendance.new(attendance_params)
    if @attendance.save
      # 申請処理など
      redirect_to attendances_path, notice: '申請が完了しました。'
    else
      render :new
    end
  end

  def edit
    # @approval = Approval.find(params[:id])
    # # その他必要な処理
    # respond_to do |format|
    #   format.html { render 'edit' } # 通常のHTMLレスポンス
    #   format.json { render json: @approval } # JSONレスポンス
    # end
  end


  # def update
  #   if @user.update_attributes(user_params)
  #     flash[:success] = "ユーザー情報を更新しました。"
  #     redirect_to @user
  #   else
  #     render :edit
  #   end
    
  #   @approval = Approval.find(params[:id])
  #   if @approval.update(approval_params)
  #     # 更新に成功した場合の処理
  #     flash[:success] =  "申請が更新されました。"
  #     redirect_to user_path
  #   else
  #     # エラーがある場合の処理
  #     render :user_path
  #   end
  # end

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
  
  
#   def approval_params
#     params.require(:approval).permit(:superior_id, :approval_list) # :other_attributesは適宜、承認に関連する他のフィールドに置き換えてください。
#   end  
#   # # このメソッドは、使用しているRailsのバージョンや具体的な実装に応じて調整してください。
#   # def set_approval_list
#   #   @approval_list = Approval.find(params[:id]) # ここでIDをもとにApprovalオブジェクトを取得します。
#   # end
  def approval_params
    params.require(:attendance).permit(:confirmation_status)
  end
  # def approval_params
  #   params.require(:approval).permit(:superior_id, :confirm) 
  # end
# # ストロングパラメータ
#   def attendance_params
#     params.require(:attendance).permit(:confirmation, :start_time, :end_time, :note)
#   end
      
      
#   def update_one_month
#     params.require(:attendance).permit(:confirmation, :start_time, :end_time, :note)
#   end  

  def user_params
    params.require(:user).permit(:name, :email, :affiliation, :password, :password_confirmation, :designated_work_start_time, :designated_work_end_time)
  end

  def basic_info_params
    params.require(:user).permit(:name, :email, :affiliation, :employee_number, :uid, :password, :basic_work_time, :designated_work_start_time, :designated_work_end_time)
  end

    # def attendance_params
    #   params.require(:approval).permit(:name, :email, :user_id, :confirmation)
    # end
    
# 1ヶ月承認申請
#   def month_approval_params 
#         # attendanceテーブルの（承認月,指示者確認、どの上長か）
#     params.require(:user).permit(:month_approval, :indicater_reply_month, :indicater_check_month)
#   end    

    # def overwork_request_params
    #   params.permit(:tomorrow_check, :next_day, :work_process, :superior)
    # end    
        
# def update_one_month_params
#   params.require(:user).permit(attendances: [:one_month_request_boss, :one_month_request_status])[:attendances]
# end 

  

    # def overwork_request_params
    #   params.permit(:tomorrow_check, :next_day, :work_process, :superior)
    # end    
        
# def update_one_month_params
#   params.require(:user).permit(attendances: [:one_month_request_boss, :one_month_request_status])[:attendances]
# end 


end




