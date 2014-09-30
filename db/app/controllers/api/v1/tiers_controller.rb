class Api::V1::TiersController < Api::V1::BaseApiController
  skip_before_action :authenticate_privileged_action, only: [:index, :show, :vote]

  def index
    tiers = Tier.showable(current_user, params[:match]).filter(params).eager_load(tier_options: :votes_for)
    render :json => tiers
  end

  def show
    tier = Tier.find_by_id params[:id]
    render :json => tier
  end

  def create
    tier = Tier.new(tier_params)
    tier.match = Match.active
    if tier.save && tier.errors.empty?
      render :json => tier
    else
      render :json => { :errors => tier.errors.full_messages },
             :status => :unprocessable_entity
    end
  end

  def vote
    match_user = MatchUser.active_match.user(current_user.id).take
    tier = Tier.eager_load(:tier_options).find_by_id params[:id]
    option = TierOption.find_by_id params[:option]

    voteTier = ::VoteTier.new

    voteTier.on(:vote_tier_successful) do
      render :json => {}
    end

    voteTier.on(:vote_tier_failed) do |errors|
      render :json => {:errors => errors}, :status => :unprocessable_entity
    end

    voteTier.call current_user, match_user, tier, option
  end

  def update
    tier = Tier.find_by_id params[:id]
    if tier.update tier_params
      render :json => tier
    else
      render :json => {:errors => tier.errors.full_messages}, :status => :unprocessable_entity
    end
  end

  protected

    def tier_params

      params.require(:tier).permit(:team_id, :name, :description, :date_release, :date_end,
                                   tier_options_attributes: [:id, :name, :description])
    end

end