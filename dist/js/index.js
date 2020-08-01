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


