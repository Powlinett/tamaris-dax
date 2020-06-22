const initClickableThumbnails = () => {
  const thumbnails = document.querySelectorAll('.thumbnail-picture');

  if (thumbnails) {
    thumbnails.forEach(thumbnail => {
      thumbnail.addEventListener("click", () => {
        const newIndex = thumbnail.querySelector('img').dataset.index
        const fullsizeImages = document.querySelectorAll('.full-size-picture img');
        const fullsizeActive = document.querySelector('.full-size-picture.active img');

        fullsizeActive.parentNode.classList.toggle('active');

        fullsizeImages.forEach(img => {
          if (img.dataset.index == newIndex) {
            img.parentNode.classList.toggle('active');
          }
        })
      })
    });
  };
};

export { initClickableThumbnails };

