require 'action_view'
require 'china_region_fu/helpers/helpers'

RSpec.shared_examples 'render region select correctly' do |invalid_proc, single_proc, multi_proc|
  context 'when pass invalid regions' do
    it 'raise error' do
      expect { invalid_proc.call }.to raise_error(ChinaRegionFu::InvalidFieldError)
    end
  end

  context 'when pass one region' do
    it 'return one select tag wrapped by a div' do
      output = single_proc.call
      expect(output).to start_with('<div class="input region province_id"><select')
      expect(output).to include('china-region-select')
      expect(output).to include('data-region-name="province_id"')
      expect(output).to include('value="16">河南省</option>')
      expect(output).not_to include('data-sub-region')
    end
  end

  context 'when pass multiple regions' do
    it 'return multiple select tags' do
      output = multi_proc.call
      expect(output).to start_with('<div class="input region province_id"><select')
      expect(output).to include('<div class="input region city_id"><select')
      expect(output).to include('<div class="input region district_id"><select')
      expect(output).to include('data-region-name="province_id"')
      expect(output).to include('data-region-name="city_id"')
      expect(output).to include('data-region-name="district_id"')
      expect(output).to include('data-sub-region="city_id"')
      expect(output).to include('data-sub-region="district_id"')
    end
  end
end

RSpec.describe ChinaRegionFu::Helpers do
  describe ChinaRegionFu::Helpers::FormHelper do
    view = ActionView::Base.new
    view.extend(ChinaRegionFu::Helpers::FormHelper)

    describe '#region_select_tag' do
      include_examples(
        'render region select correctly',
        ->() { view.region_select_tag(:invalid_region) },
        ->() { view.region_select_tag(:province_id) },
        ->() { view.region_select_tag([:province_id, :city_id, :district_id]) }
      )
    end

    describe '#region_select' do
      include_examples(
        'render region select correctly',
        ->() { view.region_select(:address, :invalid_region) },
        ->() { view.region_select(:address, :province_id) },
        ->() { view.region_select(:address, [:province_id, :city_id, :district_id]) }
      )

      it 'act as a objet field' do
        output = view.region_select(:address, [:province_id, :city_id, :district_id])
        expect(output).to include('name="address[province_id]"')
        expect(output).to include('name="address[city_id]"')
        expect(output).to include('name="address[district_id]"')
        expect(output).to include('id="address_province_id"')
        expect(output).to include('id="address_city_id"')
        expect(output).to include('id="address_district_id"')
      end
    end
  end

  describe ChinaRegionFu::Helpers::FormBuilder do
    template = ActionView::Base.new
    template.extend(ChinaRegionFu::Helpers::FormHelper)

    context 'build form for object with region' do
      view = ActionView::Helpers::FormBuilder.new('address', Address.new(province_id: 16, city_id: 166, district_id: 1513), template, {})
      view.extend(ChinaRegionFu::Helpers::FormBuilder)

      include_examples(
        'render region select correctly',
        ->() { view.region_select(:invalid_region) },
        ->() { view.region_select(:province_id) },
        ->() { view.region_select([:province_id, :city_id, :district_id]) }
      )

      it 'set correct value for each region field' do
        output = view.region_select([:province_id, :city_id, :district_id])
        expect(output).to include('<option selected="selected" value="16">河南省</option>')
        expect(output).to include('<option selected="selected" value="166">信阳市</option>')
        expect(output).to include('<option selected="selected" value="1513">商城县</option>')
      end
    end

    context 'build form for object without region' do
      view = ActionView::Helpers::FormBuilder.new('address', Address.new, template, {})
      view.extend(ChinaRegionFu::Helpers::FormBuilder)

      include_examples(
        'render region select correctly',
        ->() { view.region_select(:invalid_region) },
        ->() { view.region_select(:province_id) },
        ->() { view.region_select([:province_id, :city_id, :district_id]) }
      )

      it 'fill options for first region field' do
        output = view.region_select([:province_id, :city_id, :district_id])
        expect(output).to include('<option value="16">河南省</option>')
      end
    end

  end

end
