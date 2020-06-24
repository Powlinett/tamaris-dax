const initClickableThumbnails = () => {
  const thumbnails = document.querySelectorAll('.thumbnail-picture img');

  if (thumbnails) {
    thumbnails.forEach(thumbnail => {
      thumbnail.addEventListener('click', () => {
        const fullsizeImages = document.querySelectorAll('.full-size-picture img');
        const fullsizeActive = document.querySelector('.full-size-picture.active');
        const newIndex = thumbnail.dataset.index

        fullsizeActive.classList.remove('active');

        fullsizeImages.forEach(image => {
          if (image.dataset.index == newIndex) {
            image.parentNode.classList.add('active');
          }
        })
      })
    });
  };
};

const getNextPhoto = () => {
  const fullsizeImages = document.querySelectorAll('.full-size-picture img');
  const fullsizeActive = document.querySelector('.full-size-picture.active img');
  const newIndex = parseInt(fullsizeActive.dataset.index) + 1

  if (fullsizeImages && fullsizeActive) {
    fullsizeActive.addEventListener('click', () => {
      fullsizeActive.parentNode.classList.remove('active');

      fullsizeImages.forEach(image => {
        if (image.dataset.index == newIndex) {
          image.parentNode.classList.add('active');
        } else if (newIndex >= fullsizeImages.length) {
          fullsizeImages[0].parentNode.classList.add('active');
        };
      });
      getNextPhoto();
    })
  };
};

export { initClickableThumbnails, getNextPhoto };
