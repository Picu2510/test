// main.js — obsługa burger menu
document.addEventListener("DOMContentLoaded", function () {
    const sidebar = document.querySelector(".sidebar");
    const burger = document.getElementById("burger-toggle");

    if (!burger || !sidebar) return;

    // Przełącz sidebar
    burger.addEventListener("click", function () {
        sidebar.classList.toggle("sidebar-open");
    });

    // Po kliknięciu w link na mobilu — zamknij sidebar
    sidebar.querySelectorAll("a").forEach(link => {
        link.addEventListener("click", function () {
            if (window.innerWidth <= 768) {
                sidebar.classList.remove("sidebar-open");
            }
        });
    });
});
