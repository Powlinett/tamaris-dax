let thumbnails = document.querySelectorAll('.thumbnail-picture');

thumbnails.forEach(thumbnail => {
  thumbnail.addEventListener("click", () => {
    let newIndex = thumbnail.querySelector('img').dataset.index
    let fullsizeImages = document.querySelectorAll('.full-size-picture img');
    let fullsizeActive = document.querySelector('.full-size-picture.active img');

    fullsizeActive.parentNode.classList.toggle('active');

    fullsizeImages.forEach( img => {
      if (img.dataset.index == newIndex) {
        img.parentNode.classList.toggle('active');
      }
    })
  })
});
