module Set_Owner
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!, except: [:index, :show]
    before_action :valid_user, except: [:index, :show, :new, :create]
  end

  private

  def valid_user
    unless @collection.patternable_id == @parent.id
      redirect_to root_path, notice: 'Access denied'
    end
  end
end