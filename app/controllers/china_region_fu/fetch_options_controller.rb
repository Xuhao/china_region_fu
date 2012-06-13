module ChinaRegionFu
  class FetchOptionsController < ::ActionController::Metal
    
    def index
      if params_valid?(params) and parent_klass = params[:parent_klass].classify.safe_constantize.find(params[:parent_id])
        table_name = params[:klass].tableize
        regions = parent_klass.__send__(table_name).select("#{table_name}.id, #{table_name}.name")
        self.response_body = regions.to_json
      else
        self.response_body = [].to_json
      end
    end
    
    
    private
    
    def params_valid?(params)
      params[:klass].present? and params[:parent_klass] =~ /^province|city$/i and params[:parent_id].present?
    end
    
  end
end