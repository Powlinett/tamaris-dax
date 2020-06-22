const initChoicesSelectMenu = () => {
  const Choices = require('choices.js');

  const element = document.querySelector('#home_page_product_reference');

  if (element) {
    const selectInput = new Choices(element, {
      searchPlaceholderValue: 'Rechercher un produit par référence ou nom',
      searchResultLimit: 6,
      noResultsText: 'Aucun produit correspondant',
      itemSelectText: "Cliquer pour sélectionner"
    });
  };
};

export { initChoicesSelectMenu };
