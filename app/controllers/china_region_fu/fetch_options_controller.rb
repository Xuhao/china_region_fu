module ChinaRegionFu
  class FetchOptionsController < ::ActionController::Metal
    
    def index
      if params_valid?(params) and parent_klass = params[:parent_klass].classify.safe_constantize.find(params[:parent_id])
        table_name = params[:klass].tableize
        regions = parent_klass.__send__(table_name).select("#{table_name}.id, #{table_name}.name")
        if has_level_column?(params[:klass])
          regions = regions.order('level ASC')
        else
          regions = regions.order('name ASC')
        end
        self.response_body = regions.to_json
      else
        self.response_body = [].to_json
      end
    end
    
    
    private
    
    def has_level_column?(klass_name)
      klass_name.classify.safe_constantize.try(:column_names).to_a.include?('level')
    end
    
    def params_valid?(params)
      params[:klass].present? and params[:parent_klass] =~ /^province|city$/i and params[:parent_id].present?
    end
    
  end
end