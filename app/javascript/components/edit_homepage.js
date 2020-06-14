let Choices = require('choices.js');

let element = document.querySelector('#home_page_product_reference');

let selectInput = new Choices(element, {
  searchPlaceholderValue: 'Rechercher un produit par référence ou nom',
  searchResultLimit: 6,
  noResultsText: 'Aucun produit correspondant',
});
