const showSizesModal = () => {
  const modalLink = document.querySelector('.show-size-modal');
  const modal = document.querySelector('.sizes-modal-container');
  const body = document.querySelector('body');

  if (modalLink) {
    modalLink.addEventListener('click', (event) => {
      event.preventDefault();
      modal.classList.add('active');
      modal.style.backgroundColor = 'rgba(0, 0, 0, 0.4)';
      const modalHeight = modal.offsetHeight;
      body.style.height = modalHeight + 'px';
      body.style.overflowY = 'hidden';
    });
  };
};

const closeOnEventListener = (listenedElement, elementToClose, body) => {
    listenedElement.addEventListener('click', (event) => {
      if (event.target !== event.currentTarget) return;
      event.preventDefault();
      elementToClose.classList.remove('active');
      elementToClose.style.backgroundColor = 'transparent';
      body.style.height = 'unset';
      body.style.overflowY = 'auto';
  });
};

const closeSizesModal = () => {
  const modalCloseIcon = document.querySelector('.close-icon');
  const modal = document.querySelector('.sizes-modal-container');
  const body = document.querySelector('body');

  if (modalCloseIcon) {
    closeOnEventListener(modalCloseIcon, modal, body);
  };

  if (modal) {
    closeOnEventListener(modal, modal, body);
  };
};

export { showSizesModal, closeSizesModal };
