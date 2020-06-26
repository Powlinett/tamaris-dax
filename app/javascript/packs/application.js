import 'bootstrap';
import 'core-js/stable';
import 'regenerator-runtime/runtime';

import { initClickableThumbnails, getNextPhoto } from '../components/slider';
import { initChoicesSelectMenu } from '../components/edit_homepage';
import { showSizesModal, closeSizesModal } from '../components/sizes_modal';
import { getAnotherColor } from '../components/change_product_color';
// import { getVariantStock } from '../components/change_variants_partial';

initClickableThumbnails();
getNextPhoto();

initChoicesSelectMenu();

showSizesModal();
closeSizesModal();

getAnotherColor();
// getVariantStock();
