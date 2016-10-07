# GET: /china_region_fu/fetch_options
# Pass parent's id(by `province_id`, `city_id`) to fetch children(cities, districts),
# If no parent id passed, return all provinces.
#
# ==== Paramters
#
# * <tt>:columns</tt> - Set the columns to return for each one.
# * <tt>:parent_name</tt> - Name for parent region
# * <tt>:parent_id</tt> - ID for parent region
# * <tt>:sub_name</tt> - Name for sub region
require 'active_support/core_ext/object/blank'

class ChinaRegionFu::FetchOptionsController < ::ActionController::Metal
  def index
    validate_params!
    regions = sub_klass.order(name: :asc)
    regions = regions.where(where_value) if where_value
    regions = regions.reorder(level: :asc) if has_level_column?
    regions = regions.select(region_fields)
    self.response_body = { data: regions.as_json(only: region_fields, methods: region_methods) }.to_json
  rescue => e
    self.response_body = { error: e.message }.to_json
    self.status = 500
  end

  private

    def has_level_column?
      sub_klass.column_names.include?('level')
    end

    # Available fields in DB
    def region_fields
      sub_klass.column_names & params_columns
    end

    # Methods can be responded to
    def region_methods
      params_columns.select { |column| sub_klass.instance_methods(false).include?(column.to_sym) }
    end

    def params_columns
      @params_columns ||= params[:columns].to_s.split(',').presence || %w(id name)
    end

    def sub_klass
      @sub_klass ||= begin
        case params[:sub_name]
        when 'city', 'city_id' then City
        when 'district', 'district_id' then District
        end
      end
    end

    def where_value
      @where_value ||= begin
        case params[:parent_name]
        when 'province', 'province_id' then { province_id: params[:parent_id] }
        when 'city', 'city_id'         then { city_id: params[:parent_id] }
        else                                nil
        end
      end
    end

    def validate_params!
      (params[:parent_name].present? &&
        params[:parent_id].present? &&
        params[:sub_name].present? &&
        %w(city city_id district district_id).include?(params[:sub_name]) &&
        %w(province province_id city city_id).include?(params[:parent_name])) ||
        raise('Invalid paramters!')
    end
end
