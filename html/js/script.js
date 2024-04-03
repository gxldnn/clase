document.addEventListener('DOMContentLoaded', function () {
    const dropdownButton = document.getElementById('dropdown-button');
    const nav = document.querySelector('.header');

    dropdownButton.addEventListener('click', function () {
        nav.classList.toggle('active');
    });

    window.addEventListener('resize', function () {
        if (window.innerWidth > 800) {
            dropdownButton.classList.remove('active');
            nav.classList.remove('active');
        }
    });
});