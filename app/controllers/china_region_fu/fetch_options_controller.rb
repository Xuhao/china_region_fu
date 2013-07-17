module ChinaRegionFu
  class FetchOptionsController < ::ActionController::Metal

    def index
      if params_valid? and klass
        regions = klass.where(params[:parent_klass].foreign_key => params[:parent_id]).select('id, name').order('name ASC')
        regions.reorder('level ASC') if has_level_column?
        self.response_body = regions.to_json
      else
        self.response_body = [].to_json
      end
    end

    private

      def has_level_column?
        klass.column_names.to_a.include?('level')
      end

      def klass
        params[:klass].classify.safe_constantize
      end

      def params_valid?
        params[:klass].present? and params[:parent_klass] =~ /\Aprovince\Z|\Acity\Z/i and params[:parent_id].present?
      end

  end
end