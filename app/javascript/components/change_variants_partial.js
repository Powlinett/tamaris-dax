const refreshVariantPartial = (reference, variants) => {
  const allSizes = document.querySelector('.all-sizes');
  const variantBoxes = document.querySelectorAll('.variant-box-size');
  const lastStocks = document.querySelector('.last-stocks');

  variantBoxes.forEach(variantBox => {
    variantBox.remove();
  });
  if (lastStocks) {
    lastStocks.remove();
  };

  variants.forEach(variant => {
    const link = document.createElement('a');
    const listItem = document.createElement('li');

    link.setAttribute('href', `${reference}/${variant['size']}`);
    link.setAttribute('class', 'variant-box variant-box-size');
    listItem.setAttribute('class', 'size');
    listItem.setAttribute('data-size', variant['size']);
    listItem.innerText = variant['size'];
    if (variant['stock'] <= 0) {
      link.classList.add('unavailable');
      listItem.classList.add('unavailable');
    };

    link.appendChild(listItem);
    allSizes.appendChild(link);
  });
  getVariantStock();
};

const getVariantStock = () => {
  const variantBoxes = document.querySelectorAll('.variant-box-size');

  variantBoxes.forEach(variantBox => {
    variantBox.addEventListener('click', (event) => {
      event.preventDefault();
      const url = variantBox.getAttribute('href');

      fetch(url, { headers: { accept: 'application/json' } })
        .then(response => response.json())
        .then(data => {
          displayLastStocks(variantBox, data['variant'])
          updateUrl(data['product']['reference'], data['variant']['size']);
        });
    });
  });
};

const displayLastStocks = (variantBox, variant) => {
  removeFormerLastStocks();
  if (variant['stock'] < 10) {
    const sizesContent = document.querySelector('.sizes-content');

    const lastStocks = document.createElement('p');
    lastStocks.setAttribute('class', 'last-stocks');
    if (variant['stock'] > 1) {
      lastStocks.innerText = `Plus que ${variant['stock']} exemplaires en stock`;
    } else {
      lastStocks.innerText = `Plus que ${variant['stock']} exemplaire en stock`;
    };
    sizesContent.appendChild(lastStocks);
  };
};

const removeFormerLastStocks = () => {
  const lastStocks = document.querySelector('.last-stocks');
  if (lastStocks) {
    lastStocks.remove();
  };
};

const updateUrl = (reference, variantSize) => {
  const state = history.state
  const title = history.title

  window.history.replaceState(state, title, `${reference}/${variantSize}`);
};

export { refreshVariantPartial };
