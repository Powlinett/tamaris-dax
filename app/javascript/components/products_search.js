import LogoTamaris from '../../assets/images/logo-tamaris';

const changeBrandLogoOnMobile = () => {
  const input = document.querySelector('#query');
  const logo = document.querySelector('.navbar-brand');

  if (window.innerWidth < 576 && input) {
    input.addEventListener('focus', () => {
      logo.style.backgroundImage = "url('https://tamaris.com/on/demandware.static/Sites-FR-Site/-/default/dw70c61ea2/images/favicon-tamaris.ico')";
    });

    input.addEventListener('blur', () => {
      console.log(LogoTamaris);
      logo.style.backgroundImage = LogoTamaris;
    });
  };
};

export { changeBrandLogoOnMobile };
