import { initClickableThumbnails, getNextPhoto } from '../components/slider';
import { refreshVariantPartial } from '../components/change_variants_partial';

const getAnotherColor = () => {
  const colorLinks = document.querySelectorAll('.variant-box-color');

  if (colorLinks) {
    colorLinks.forEach(colorLink => {
      colorLink.addEventListener('click', (event) => {
        event.preventDefault();
        const url = colorLink.getAttribute('href');

        fetch(url, { headers: { accept: 'application/json' } })
          .then(response => response.json())
          .then(data => {
            underlineNewColor(data['product']['reference']);
            renderNewThumbnails(data['product']);
            renderNewFullsizePhotos(data['product']);
            updateDescription(data['product']['reference']);
            refreshVariantPartial(data['product']['reference'], data['variants']);
            changeUrlReference(data['product']['reference']);
          });
      });
    });
  };
};

const underlineNewColor = (reference) => {
  const formerColor = document.querySelector('.underline.is-selected');
  const selectedColor = document.querySelector(`a[data-ref="${reference}"`).children[0];

  formerColor.classList.remove('is-selected');
  selectedColor.classList.add('is-selected');
};

const renderNewThumbnails = (productData) => {
  const formerThumbnails = document.querySelectorAll('li.thumbnail-picture');

  formerThumbnails.forEach(thumbnail => {
    thumbnail.remove();
  });

  const thumbnailsList = document.querySelector('ul.thumbnails-pictures');

  productData['photos_urls'].forEach((photoUrl, index) => {
    const listItem = document.createElement('li');
    const itemImg = document.createElement('img');

    listItem.setAttribute('class', 'thumbnail-picture');
    itemImg.setAttribute('src', `${photoUrl}`);
    itemImg.setAttribute('alt', `${productData['model']} - ${productData['color']} (${index})`);
    itemImg.setAttribute('data-index', `${index}`);

    listItem.appendChild(itemImg);
    thumbnailsList.appendChild(listItem);
  });
  initClickableThumbnails();
};

const renderNewFullsizePhotos = (productData) => {
  const formerFullsizePictures = document.querySelectorAll('li.full-size-picture');

  formerFullsizePictures.forEach(picture => {
    picture.remove();
  });

  const fullsizePicturesList = document.querySelector('ul.picture-wrapper');

  productData['photos_urls'].forEach((photoUrl, index) => {
    const listItem = document.createElement('li');
    const itemImg = document.createElement('img');

    listItem.setAttribute('class', 'full-size-picture');
    if (index == 0) {
      listItem.classList.add('active');
    };

    itemImg.setAttribute('src', `${photoUrl}`);
    itemImg.setAttribute('alt', `${productData['model']} - ${productData['color']} (${index})`);
    itemImg.setAttribute('data-index', `${index}`);

    listItem.appendChild(itemImg);
    fullsizePicturesList.appendChild(listItem);
  });
  getNextPhoto();
};

const updateDescription = (reference) => {
  const formerReference = document.querySelector('.feature-value');

  formerReference.innerText = `${reference}`;
};

const changeUrlReference = (reference) => {
  const newreference = reference;
  const state = history.state
  const title = history.title

  window.history.replaceState(state, title, `${reference}`);
};

export { getAnotherColor };
