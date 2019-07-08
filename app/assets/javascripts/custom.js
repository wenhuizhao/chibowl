function getCartItems(){
  var cartData = sessionStorage.getItem("cart");
  var cart = JSON.parse(cartData || "{}");
  return cart.items;
}
function viewCart(){
  var items = getCartItems();
  var productIds = Object.keys(items);
  var quantities = productIds.map(id=>items[id].quantity);
  window.location = "/orders/cart?product_ids="+productIds+"&quantities="+quantities;  
}

function updateCartBadge() {
  var items = getCartItems();
  if (!items || Object.keys(items).length === 0) {
    $("#cart-data-badge").attr("data-badge", 0)
    return;
  }
  var totalQuantity = 0;
  Object.keys(items).forEach(productId => {
    totalQuantity += items[productId].quantity;
  });
  $("#cart-data-badge").attr("data-badge", totalQuantity);
}

function updateSideCart() {
  var items = getCartItems();
  if (!items || Object.keys(items).length === 0) {
    $('#side-cart-ul').empty();
    return;
  }
  var subTotal = 0;
  Object.keys(items).forEach(productId => {
    item = items[productId];
    var price = item.sellPrice ? item.sellPrice : item.price;
    subTotal += item.quantity * price;
    $('#side-cart-ul').empty();
    $('#side-cart-ul').append(
      '<li class="oxy-list__item" id="side-cart-li-'+productId+ '">' +
      ' <a href="single-product.html" class="oxy-list__icon">'+
      '   <image src='+item.thumb+'>' +
      ' </a>'+
      ' <div class="oxy-list__item-text">'+
      '   <a href="single-product.html" class="oxy-list__title">'+item.name+'</a>'+
      '   <span class="oxy-list__subtitle">'+ item.price.toFixed(2) + '<span>'+
      ' </div>'+
      ' <div class="oxy-list__item-secondary-action">' +
      ' <a href="javascript:void(0);" onClick="removeFromCart('+ productId +');" title="Remove this item" class="mdl-button mdl-js-button mdl-button--accent mdl-button--icon"><i class="material-icons">close</i></a>'+
      ' </div>'+
      '</li>');
    $('#side-cart-subtotal').html(subTotal.toFixed(2));
  });
}

function removeFromCart(productId){
  var cartData = sessionStorage.getItem("cart");
  var cart = JSON.parse(cartData || "{}");
  var cartCopy = cart || {};
  var items = (cartCopy || {}).items || {};

  if (!items || Object.keys(items).length === 0 || !items[productId]) {
    return;
  }
  delete items[productId];
  cartCopy.items = items;
  sessionStorage.setItem("cart", JSON.stringify(cartCopy));
  updateCartBadge();
  //$('#side-cart-li-'+productId).remove();
  updateSideCart();
  return false;
}
function addToCart(productId, price, quantity, name, sellPrice, thumb) {
  var cartData = sessionStorage.getItem("cart");
  var cart = JSON.parse(cartData || "{}");
  var cartCopy = cart || {};
  var items = (cartCopy || {}).items || {};
  if (items[productId]) {
    items[productId].quantity += quantity;
    items[productId].price = price;
    (items[productId].sellPrice = sellPrice), (items[productId].name = name);
    items[productId].thumb = thumb;
  } else {
    items[productId] = {
      price: price,
      quantity: quantity,
      sellPrice: sellPrice,
      name: name,
      thumb: thumb
    };
  }
  cartCopy.items = items;
  sessionStorage.setItem("cart", JSON.stringify(cartCopy));
  updateCartBadge();
  updateSideCart();
}
$(document).ready(function() {
  updateCartBadge();
  updateSideCart();
});
