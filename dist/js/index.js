import {capture}  from './html-screen-capture.min.js';
import {registerEventHandlers} from './RegisterEventHandlers.js';

registerEventsNavigation();
registerEventHandlers();

const pageActionLinks = document.querySelectorAll("a[data-action='page-action']");

console.log(window.location.href);

[...pageActionLinks].forEach((pageActionLink)=> {
    pageActionLink.addEventListener('click', (e) => {
        deselectAllPageActionLinks();
        e.currentTarget.classList.add('nav-selected');
    })
});

const deselectAllPageActionLinks = () => {
    [...pageActionLinks].forEach((pageActionLink)=> {
        pageActionLink.classList.remove('nav-selected')
    });        
}

const setCurrentPageActionLink = () => {        
    const currentUrl = window.location.href;

    [...pageActionLinks].forEach((pageActionLink) => {
        if (currentUrl.includes(pageActionLink.id)) {
            pageActionLink.classList.add('nav-selected');
            return;
        }            
    });        
}

setCurrentPageActionLink();


//document.addEventListener('DOMContentLoaded', (e) => {
    const submitbutton = document.getElementById('submitform');
    submitbutton.addEventListener('click', (e) => {
        const form = document.getElementById('form1');
        const htmltag = document.querySelector('html');
        const target = document.querySelector('input[name="allhtml"]');
        target.value = htmltag.innerHTML;
        console.log(htmltag.innerHTML);
        form.submit();
    });
//});