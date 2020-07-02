import 'bootstrap';
import 'core-js/stable';
import 'regenerator-runtime/runtime';

import { initClickableThumbnails } from '../components/slider';
import { initChoicesSelectMenu } from '../components/edit_homepage';
import { showSizesModal, closeSizesModal } from '../components/sizes_modal';
import { changeBrandLogoOnMobile } from '../components/products_search';

changeBrandLogoOnMobile();

initClickableThumbnails();

initChoicesSelectMenu();

showSizesModal();
closeSizesModal();
