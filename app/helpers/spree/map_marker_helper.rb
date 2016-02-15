class MapMarkerHelper
  class << self
    def getMarkers(stores, geocoder_result)
      user_marker = Gmaps4rails.build_markers([geocoder_result]) do |gr, marker|
        marker.lat gr["latitude"]
        marker.lng gr["longitude"]
        marker.infowindow gr["ip"]
      end

      index = 0
      store_markers = Gmaps4rails.build_markers(stores) do |store, marker|
        marker.lat store[:latitude]
        marker.lng store[:longitude]
        marker.infowindow render_to_string(:partial => "/spree/partials/store_marker", locals: { store: store, index: index})
        marker.json({ id: index })
        index += 1
      end

      store_markers + user_marker
    end
  end
end
