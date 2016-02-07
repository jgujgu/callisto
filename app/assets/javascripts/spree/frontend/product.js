$(function() {
  Spree.addImageHandlers = function() {
    var thumbnails;
    thumbnails = $('#product-images ul.thumbnails');
    ($('#main-image')).data('selectedThumb', ($('#main-image img')).attr('src'));
    thumbnails.find('li').eq(0).addClass('selected');
    thumbnails.find('a').on('click', function(event) {
      ($('#main-image')).data('selectedThumb', ($(event.currentTarget)).attr('href'));
      ($('#main-image')).data('selectedThumbId', ($(event.currentTarget)).parent().attr('id'));
      thumbnails.find('li').removeClass('selected');
      ($(event.currentTarget)).parent('li').addClass('selected');
      return false;
    });
    thumbnails.find('li').on('mouseenter', function(event) {
      return ($('#main-image img')).attr('src', ($(event.currentTarget)).find('a').attr('href'));
    });
    return thumbnails.find('li').on('mouseleave', function(event) {
      return ($('#main-image img')).attr('src', ($('#main-image')).data('selectedThumb'));
    });
  };
  Spree.showVariantImages = function(variantId) {
    var currentThumb, newImg, thumb;
    ($('li.vtmb')).hide();
    ($('li.tmb-' + variantId)).show();
    currentThumb = $('#' + ($('#main-image')).data('selectedThumbId'));
    if (!currentThumb.hasClass('vtmb-' + variantId)) {
      thumb = $(($('#product-images ul.thumbnails li:visible.vtmb')).eq(0));
      if (!(thumb.length > 0)) {
        thumb = $(($('#product-images ul.thumbnails li:visible')).eq(0));
      }
      newImg = thumb.find('a').attr('href');
      ($('#product-images ul.thumbnails li')).removeClass('selected');
      thumb.addClass('selected');
      ($('#main-image img')).attr('src', newImg);
      ($('#main-image')).data('selectedThumb', newImg);
      return ($('#main-image')).data('selectedThumbId', thumb.attr('id'));
    }
  };
  Spree.updateVariantPrice = function(variant) {
    var variantPrice;
    variantPrice = variant.data('price');
    if (variantPrice) {
      return ($('.price.selling')).text(variantPrice);
    }
  };
  var $variantSelect = $('#variant_id');
  if ($variantSelect) {
    var $selectedVariant = $("#variant_id option:selected");
    Spree.showVariantImages($selectedVariant.val());
    Spree.updateVariantPrice($selectedVariant);
  }
  Spree.addImageHandlers();
  return $variantSelect.on('change',function(event) {
    var $selectedVariant = $("#variant_id option:selected");
    Spree.showVariantImages($selectedVariant.val());
    return Spree.updateVariantPrice($selectedVariant);
  });
});
