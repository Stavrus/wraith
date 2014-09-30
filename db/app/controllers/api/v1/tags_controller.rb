class Api::V1::TagsController < Api::V1::BaseApiController
  skip_before_action :authenticate_user_action, except: :update
  skip_before_action :authenticate_privileged_action, except: :update

  def index
    # Eager loading still generated N+1 queries.
    # This will have to be redone.
    sql = %Q{SELECT tags.id AS id, tags.source_id AS source_id, tags.target_id AS target_id,
                    tags.match_id AS match_id, tags.created_at AS created_at,
                    source_users.name AS source, target_users.name AS target FROM tags
              LEFT OUTER JOIN match_users source_match ON source_match.id = tags.source_id
              LEFT OUTER JOIN users source_users ON source_users.id = source_match.user_id
              LEFT OUTER JOIN match_users target_match ON target_match.id = tags.target_id 
              LEFT OUTER JOIN users target_users ON target_users.id = target_match.user_id}

    # Filter by match (force a lookup through find_by_id to make sure match exists)
    match = Match.find_by_id params[:match]
    sql << " WHERE tags.match_id = #{match.id}" unless match.nil?

    sql << ' ORDER BY tags.created_at DESC'

    tags = ActiveRecord::Base.connection.execute(sql)
    
    attributes = ['id', 'source_id', 'target_id', 'match_id', 'created_at', 'source', 'target']
    tags.map { |x| x.slice!(*attributes) }

    render :json => tags
  end

  def show
    tag = Tag.find_by_id params[:id]
    render :json => tag
  end

  def create
    source = MatchUser.active_match.find_by_uid(tag_params[:source])
    target = Token.active_match.find_by_uid(tag_params[:target]).match_user

    perftag = ::PerformTag.new

    perftag.on(:perform_tag_successful) do |tag|
      render :json => tag
    end

    perftag.on(:perform_tag_failed) do |errors|
      render :json => {:errors => errors}, :status => :unprocessable_entity
    end

    perftag.call(Match.active, source, target, tag_params[:latitude], tag_params[:longitude])
  end

  def update
    tag = Tag.find_by_id params[:id]
    user.update tag_params
  end

  protected

    def tag_params
      params.require(:tag).permit(:source, :target, :latitude, :longitude)
    end

end