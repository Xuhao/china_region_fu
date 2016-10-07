require 'china_region_fu/helpers/utils'

RSpec.describe ChinaRegionFu::Utils do
  let(:proxy) { Class.new { extend ChinaRegionFu::Utils } }

  describe '#china_region_fu_js' do
    it 'return trusted Javascript snippet' do
      js = proxy.china_region_fu_js
      expect(js).to match(/^\s*<script type="text\/javascript">/)
      expect(js).to match(/<script type="text\/javascript">\s*/)
    end
  end

  describe '#append_html_class_option' do
    context 'when option not have key `:class`' do
      let (:html_options) { {} }
      it 'append china-region-select to `:class` option' do
        new_html_options = proxy.append_html_class_option(html_options)
        expect(new_html_options[:class]).to eq(' china-region-select')
        expect(html_options[:class]).to be_nil
      end
    end

    context 'when option have key `:class`' do
      let (:html_options) { { class: 'some class' } }
      it 'append china-region-select to `:class` option' do
        new_html_options = proxy.append_html_class_option(html_options)
        expect(new_html_options[:class]).to eq('some class china-region-select')
        expect(html_options[:class]).to eq('some class')
      end
    end
  end

  describe '#append_html_data_option' do
    context 'when `sub_region` be passed' do
      let(:origin_html_options) { {} }
      let(:html_options) { proxy.append_html_data_option('province_id', 'city_id', origin_html_options) }
      it 'append `sub_region` to options[:data][:sub_region]' do
        expect(html_options[:data]).to eq(region_name: 'province_id', sub_region: 'city_id')
        expect(origin_html_options).to eq({})
      end
    end

    context 'when `sub_region` not be passed' do
      let(:origin_html_options) { {} }
      let(:html_options) { proxy.append_html_data_option('province_id', nil, origin_html_options) }
      it 'append `sub_region` to options[:data][:sub_region]' do
        expect(html_options[:data]).to eq(region_name: 'province_id')
        expect(origin_html_options).to eq({})
      end
    end
  end

  describe '#append_html_options' do
    context 'when `sub_region` be passed' do
      let(:origin_html_options) { {} }
      let(:html_options) { proxy.append_html_options('province_id', 'city_id', origin_html_options) }

      it 'append css class and data' do
        expect(html_options[:data]).to eq(region_name: 'province_id', sub_region: 'city_id')
        expect(html_options[:class]).to eq(' china-region-select')
        expect(origin_html_options).to eq({})
      end
    end

    context 'when `sub_region` not be passed' do
      let(:origin_html_options) { { class: 'some class' } }
      let(:html_options) { proxy.append_html_options('province_id', nil, origin_html_options) }
      it 'append `sub_region` to options[:data][:sub_region]' do
        expect(html_options[:data]).to eq(region_name: 'province_id')
        expect(html_options[:class]).to eq('some class china-region-select')
        expect(origin_html_options).to eq(class: 'some class')
      end
    end
  end

  describe '#append_prompt' do
    let(:options) { { include_blank: false, province_prompt: 'select province', city_prompt: 'select city', district_prompt: 'select district' } }

    it 'extract promp for passed region' do
      expect(proxy.append_prompt('province', options)).to eq(include_blank: false, prompt: 'select province')
      expect(proxy.append_prompt('city_id', options)).to eq(include_blank: false, prompt: 'select city')
      expect(proxy.append_prompt('district', options)).to eq(include_blank: false, prompt: 'select district')
    end
  end

end
