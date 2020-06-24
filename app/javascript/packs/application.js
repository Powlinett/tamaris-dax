import 'bootstrap';
import 'core-js/stable';
import 'regenerator-runtime/runtime';

import { initClickableThumbnails, getNextPhoto } from '../components/slider';
import { initChoicesSelectMenu } from '../components/edit_homepage';
import { showSizesModal, closeSizesModal } from '../components/sizes_modal';

initClickableThumbnails();
getNextPhoto();

initChoicesSelectMenu();

showSizesModal();
closeSizesModal();
