class Api::V1::AntiviriController < Api::V1::BaseApiController
  skip_before_action :authenticate_privileged_action, :except => :use

  def index
    avs = Antivirus.eager_load(match_user: :user).filter(params)
    render :json => avs
  end

  def show
    av = Antivirus.find_by_id params[:id]
    render :json => av
  end

  def create
    createAv = ::CreateAntiviri.new

    createAv.on(:create_antiviri_successful) do |avs|
      render :json => avs
    end

    createAv.on(:create_antiviri_failed) do |errors|
      render :json => {:errors => errors}, :status => :unprocessable_entity
    end

    createAv.call params[:quantity], Match.active
  end

  def use
    match_user = MatchUser.active_match.user(current_user.id).take
    av = Antivirus.where(:uid => params[:code], :match => params[:match])

    useAv = ::UseAntiviri.new

    useAv.on(:use_antivirus_successful) do
      render :json => {}
    end

    useAv.on(:use_antivirus_failed) do |errors|
      render :json => {:errors => errors}, :status => :unprocessable_entity
    end

    useAv.call match_user, av
  end

  def update
    av = Antivirus.find_by_id params[:id]
    if av.update av_params
      render :json => av
    else
      render :json => {:errors => av.errors.full_messages}, :status => :unprocessable_entity
    end
  end

  protected

    def av_params
      params.require(:antivirus).permit(:description)
    end

end