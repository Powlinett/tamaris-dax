import LogoTamaris from '../../assets/images/logo-tamaris.svg';
import CircleLogo from '../../assets/images/logo-tamaris.png';

const changeBrandLogoOnMobile = () => {
  const input = document.querySelector('#query');
  const logo = document.querySelector('.navbar-brand');

  if (window.innerWidth < 376 && input) {
    input.addEventListener('focus', () => {
      logo.style.backgroundImage = `url(${CircleLogo})`;
    });

    input.addEventListener('blur', () => {
      logo.style.backgroundImage = `url(${LogoTamaris})`;
    });
  };
};

const cleanNavbar = () => {
  const input = document.querySelector('#query');
  const navItems = document.querySelector('.nav-items');

  if (window.innerWidth > 768 && input) {
    input.addEventListener('focus', () => {
      navItems.style.display = "none";
    });

    input.addEventListener('blur', () => {
      navItems.style.display = "flex";
    });
  };
}

export { changeBrandLogoOnMobile, cleanNavbar };
