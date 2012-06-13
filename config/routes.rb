Rails.application.routes.draw do
  match '/china_region_fu/fetch_options', to: ChinaRegionFu::FetchOptionsController.action(:index)
end