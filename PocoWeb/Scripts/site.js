(function () {
    'use strict';
    function $(s, r) { return (r || document).querySelector(s); }
    function $$(s, r) { return Array.prototype.slice.call((r || document).querySelectorAll(s)); }

    // toast auto-hide
    var toast = $('#toast');
    if (toast) {
        setTimeout(function () { toast.classList.add('hide'); }, 3800);
        setTimeout(function () { if (toast.parentNode) toast.parentNode.removeChild(toast); }, 4400);
    }

    // mobile nav + search
    var nt = $('#navToggle'), nav = $('#mainNav');
    if (nt && nav) nt.addEventListener('click', function () { nav.classList.toggle('open'); });
    var st = $('#searchToggle');
    if (st) st.addEventListener('click', function () {
        var pop = $('.search-pop');
        if (!pop) return;
        pop.classList.toggle('open');
        var inp = $('input[type=text]', pop);
        if (inp && pop.classList.contains('open')) inp.focus();
    });

    // hero slider
    var hero = $('#hero');
    if (hero) {
        var slides = $$('.slide', hero), dots = $$('.hero-dots button', hero), cur = 0, timer;
        function show(i) {
            cur = (i + slides.length) % slides.length;
            slides.forEach(function (s, n) { s.classList.toggle('active', n === cur); });
            dots.forEach(function (d, n) { d.classList.toggle('on', n === cur); });
        }
        function auto() { clearInterval(timer); timer = setInterval(function () { show(cur + 1); }, 6500); }
        dots.forEach(function (d, n) { d.addEventListener('click', function () { show(n); auto(); }); });
        auto();
    }

    // popular dishes carousel
    var track = $('#popTrack');
    if (track) {
        function step() { var item = $('.car-item', track); return item ? item.offsetWidth + 30 : 300; }
        var prev = $('#popPrev'), next = $('#popNext');
        if (prev) prev.addEventListener('click', function () { track.scrollBy({ left: -step(), behavior: 'smooth' }); });
        if (next) next.addEventListener('click', function () {
            if (track.scrollLeft + track.clientWidth >= track.scrollWidth - 4) track.scrollTo({ left: 0, behavior: 'smooth' });
            else track.scrollBy({ left: step(), behavior: 'smooth' });
        });
    }

    // testimonials slider
    var tt = $('#tTrack'), td = $('#tDots');
    if (tt && td) {
        var items = $$('.t-item', tt), pos = 0, tTimer;
        function perView() { return window.innerWidth <= 640 ? 1 : (window.innerWidth <= 900 ? 2 : 3); }
        function positions() { return Math.max(1, items.length - perView() + 1); }
        function build() {
            td.innerHTML = '';
            for (var i = 0; i < positions(); i++) {
                (function (n) {
                    var b = document.createElement('button');
                    b.type = 'button'; b.setAttribute('aria-label', 'Slide ' + (n + 1));
                    b.addEventListener('click', function () { go(n); restart(); });
                    td.appendChild(b);
                })(i);
            }
            go(Math.min(pos, positions() - 1));
        }
        function go(n) {
            pos = n;
            var w = items.length ? items[0].offsetWidth : 0;
            tt.style.transform = 'translateX(' + (-pos * w) + 'px)';
            $$('button', td).forEach(function (b, i) { b.classList.toggle('on', i === pos); });
        }
        function restart() { clearInterval(tTimer); tTimer = setInterval(function () { go((pos + 1) % positions()); }, 5000); }
        window.addEventListener('resize', build);
        build(); restart();
    }

    // dual price slider
    var pf = $('#priceFilter');
    if (pf) {
        var a = $('#rangeMin'), b = $('#rangeMax'), fill = $('#rangeFill'), lo = $('#lblMin'), hi = $('#lblMax');
        var max = parseInt(pf.getAttribute('data-max'), 10) || 20;
        var hMin = $('input[id$="hfMin"]'), hMax = $('input[id$="hfMax"]');
        function upd(src) {
            var x = parseInt(a.value, 10), y = parseInt(b.value, 10);
            if (x > y) { if (src === a) { a.value = y; x = y; } else { b.value = x; y = x; } }
            lo.textContent = x; hi.textContent = y;
            fill.style.left = (x / max * 100) + '%';
            fill.style.width = ((y - x) / max * 100) + '%';
            if (hMin) hMin.value = x;
            if (hMax) hMax.value = y;
        }
        a.addEventListener('input', function () { upd(a); });
        b.addEventListener('input', function () { upd(b); });
        upd();
    }

    // delivery bike scroll animation
    var deliverySection = $('.delivery');
    var bikeContainer = $('.bike-anim-container');
    if (deliverySection && bikeContainer) {
        var observer = new IntersectionObserver(function (entries) {
            entries.forEach(function (entry) {
                if (entry.isIntersecting) {
                    bikeContainer.classList.add('anim');
                }
            });
        }, { threshold: 0.3 });
        observer.observe(deliverySection);
    }
})();
