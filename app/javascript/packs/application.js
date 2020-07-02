import 'bootstrap';
import 'core-js/stable';
import 'regenerator-runtime/runtime';

import { initClickableThumbnails } from '../components/slider';
import { initChoicesSelectMenu } from '../components/edit_homepage';
import { showSizesModal, closeSizesModal } from '../components/sizes_modal';
import { changeBrandLogoOnMobile, cleanNavbar } from '../components/products_search';

changeBrandLogoOnMobile();
cleanNavbar();

initClickableThumbnails();

initChoicesSelectMenu();

showSizesModal();
closeSizesModal();
