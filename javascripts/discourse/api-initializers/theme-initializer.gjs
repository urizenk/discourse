import { apiInitializer } from "discourse/lib/api";

export default apiInitializer("1.8.0", (api) => {
  const router = api.container.lookup("router:main");
  
  // 页面变化时初始化
  api.onPageChange((url) => {
    initNavPosition();
    highlightActiveCategory(url);
    highlightActiveTag(url);
  });
  
  // 导航项点击
    document.addEventListener("click", (e) => {
        const item = e.target.closest(".rtt-item");
    if (item) {
      e.preventDefault();
        const url = item.dataset.url;
        if (url) {
        router.transitionTo(url);
      }
      return;
    }
    
    // 标签导航点击
    const tagItem = e.target.closest(".tag-nav-item");
    if (tagItem) {
      e.preventDefault();
      const href = tagItem.getAttribute("href");
      if (href) {
        router.transitionTo(href);
      }
    }
    
    // 左箭头
    const leftArrow = e.target.closest(".rtt-arrow-left");
    if (leftArrow) {
      const container = document.querySelector(".rtt-inner");
      if (container) {
        container.scrollBy({ left: -200, behavior: "smooth" });
      }
    }
    
    // 右箭头
    const rightArrow = e.target.closest(".rtt-arrow-right");
    if (rightArrow) {
      const container = document.querySelector(".rtt-inner");
      if (container) {
        container.scrollBy({ left: 200, behavior: "smooth" });
      }
    }
  });
  
  // 滚动监听
  window.addEventListener("scroll", onScroll, { passive: true });
});

// 滚动节流
let ticking = false;

function onScroll() {
    if (!ticking) {
        requestAnimationFrame(updateHeader);
        ticking = true;
    }
}

function updateHeader() {
  const bar = document.querySelector("#robotime-tag-top");
  if (bar) {
    const scrollTop = window.pageYOffset || document.documentElement.scrollTop;
    if (scrollTop > 200) {
      bar.classList.add("hideImg");
    } else if (scrollTop < 120) {
      bar.classList.remove("hideImg");
    }
  }
    ticking = false;
}

// 初始化导航位置
function initNavPosition() {
    const header = document.querySelector(".d-header-wrap");
    const bar = document.querySelector("#robotime-tag-top");
  const tagNav = document.querySelector("#robotime-tag-nav");
  
    if (header && bar && !bar.dataset.inserted) {
      header.insertAdjacentElement("afterend", bar);
      bar.dataset.inserted = "true";
    }
  
  if (bar && tagNav && !tagNav.dataset.inserted) {
    bar.insertAdjacentElement("afterend", tagNav);
    tagNav.dataset.inserted = "true";
  }
}

// 高亮当前分类
function highlightActiveCategory(currentUrl) {
  const items = document.querySelectorAll(".rtt-item");
  items.forEach((item) => {
    item.classList.remove("active");
    const category = item.dataset.category;
    const itemUrl = item.dataset.url;
    
    if (category === "home" && (currentUrl === "/" || currentUrl === "")) {
      item.classList.add("active");
    } else if (category && category !== "home") {
      if (currentUrl.includes(`/c/${category}`) || currentUrl.includes(itemUrl)) {
        item.classList.add("active");
      }
    }
  });
}

// 高亮当前标签
function highlightActiveTag(currentUrl) {
  const items = document.querySelectorAll(".tag-nav-item");
  items.forEach((item) => {
    item.classList.remove("active");
    const href = item.getAttribute("href");
    if (href && currentUrl.includes(href) && href !== "/tags") {
      item.classList.add("active");
    }
  });
}
