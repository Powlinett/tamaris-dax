const showSizesModal = () => {
  const modalLink = document.querySelector('.show-size-modal');
  const modal = document.querySelector('.sizes-modal-container');

  if (modalLink) {
    modalLink.addEventListener('click', (event) => {
      event.preventDefault();
      modal.classList.add('active');
      modal.style.backgroundColor = 'rgba(0, 0, 0, 0.4)';
    });
  };
};

const closeOnEventListener = (listenedElement, elementToClose) => {
    listenedElement.addEventListener('click', (event) => {
      if (event.target !== event.currentTarget) return;
      event.preventDefault();
      elementToClose.classList.remove('active');
      elementToClose.style.backgroundColor = 'transparent';
  });
};

const closeSizesModal = () => {
  const modalCloseIcon = document.querySelector('.close-icon');
  const modal = document.querySelector('.sizes-modal-container');

  if (modalCloseIcon) {
    closeOnEventListener(modalCloseIcon, modal);
  };

  if (modal) {
    closeOnEventListener(modal, modal);
  };
};

export { showSizesModal };
export { closeSizesModal };
