Deface::Override.new(virtual_path: 'spree/admin/shared/_configuration_menu',
                     name: 'add_social_providers_link_configuration_menu',
                     insert_bottom: '[data-hook="admin_configurations_sidebar_menu"]',
                     text: '
<% if current_spree_user.has_spree_role?("super_admin") %>
<%= configurations_sidebar_menu_item Spree.t(:social_authentication_methods), spree.admin_authentication_methods_path %>
<% end %>
',
                     disabled: false)
