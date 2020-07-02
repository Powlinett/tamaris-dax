import LogoTamaris from '../../assets/images/logo-tamaris.svg';
import CircleLogo from '../../assets/images/tamaris_brand_circle.gif';

const changeBrandLogoOnMobile = () => {
  const input = document.querySelector('#query');
  const logo = document.querySelector('.navbar-brand');

  if (window.innerWidth < 576 && input) {
    input.addEventListener('focus', () => {
      logo.style.backgroundImage = `url(${CircleLogo})`;
    });

    input.addEventListener('blur', () => {
      logo.style.backgroundImage = `url(${LogoTamaris})`;
    });
  };
};

export { changeBrandLogoOnMobile };
