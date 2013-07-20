module ChinaRegionFu
  class FetchOptionsController < ::ActionController::Metal

    def index
      if params_valid? and klass and parent_klass and (parent_object = parent_klass.find(params[:parent_id]))
        regions = parent_object.__send__(klass.model_name.plural).select("#{klass.table_name}.id, #{klass.table_name}.name").order("#{klass.table_name}.name ASC")
        regions.reorder("#{klass.table_name}.level ASC") if has_level_column?
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
        params[:klass].sub(/_id\Z/, '').classify.safe_constantize
      end

      def parent_klass
        parent_klass_name.classify.safe_constantize
      end

      def parent_klass_name
        params[:parent_klass].sub(/_id\Z/, '')
      end

      def params_valid?
        params[:klass].present? and parent_klass_name=~ /\Aprovince\Z|\Acity\Z/i and params[:parent_id].present?
      end

  end
end