(() => {
  const root = document.documentElement;
  const reduceMotion = window.matchMedia("(prefers-reduced-motion: reduce)");
  const header = document.querySelector(".topline");
  const menuButton = document.querySelector(".nav-toggle");
  const nav = document.querySelector("#chapter-navigation");

  if (header && menuButton && nav) {
    const closeMenu = () => {
      header.classList.remove("menu-open");
      menuButton.setAttribute("aria-expanded", "false");
    };

    menuButton.addEventListener("click", () => {
      const open = menuButton.getAttribute("aria-expanded") !== "true";
      menuButton.setAttribute("aria-expanded", String(open));
      header.classList.toggle("menu-open", open);
    });
    nav.addEventListener("click", (event) => {
      if (event.target.closest("a")) closeMenu();
    });
    document.addEventListener("keydown", (event) => {
      if (event.key === "Escape" && menuButton.getAttribute("aria-expanded") === "true") {
        closeMenu();
        menuButton.focus();
      }
    });
  }

  const navLinks = [...document.querySelectorAll("#chapter-navigation a[href^='#']")];
  const navTargets = navLinks
    .map((link) => document.querySelector(link.getAttribute("href")))
    .filter(Boolean);

  if ("IntersectionObserver" in window) {
    const revealTargets = document.querySelectorAll(
      ".chapter-head, .chapter-image, .project, .architecture, .timeline-card, .focus-card, .telemetry-card, .arsenal article, .metric, .contact-heading, .contact-links, .contact-form",
    );
    revealTargets.forEach((element, index) => {
      element.setAttribute("data-reveal", "");
      element.style.setProperty("--reveal-delay", `${(index % 4) * 55}ms`);
    });

    const revealObserver = new IntersectionObserver(
      (entries, observer) => {
        entries.forEach((entry) => {
          if (entry.isIntersecting) {
            entry.target.classList.add("is-visible");
            observer.unobserve(entry.target);
          }
        });
      },
      { threshold: 0.12, rootMargin: "0px 0px -36px 0px" },
    );
    revealTargets.forEach((element) => revealObserver.observe(element));

    if (navTargets.length) {
      const navObserver = new IntersectionObserver(
        (entries) => {
          const visible = entries
            .filter((entry) => entry.isIntersecting)
            .sort((a, b) => a.boundingClientRect.top - b.boundingClientRect.top)[0];
          if (!visible) return;
          navLinks.forEach((link) => {
            if (link.hash === `#${visible.target.id}`) {
              link.setAttribute("aria-current", "location");
            } else {
              link.removeAttribute("aria-current");
            }
          });
        },
        { rootMargin: "-18% 0px -68% 0px", threshold: 0 },
      );
      navTargets.forEach((target) => navObserver.observe(target));
    }

    root.classList.add("js-ready");
  }

  document.querySelectorAll(".stack").forEach((stack) => {
    const labels = stack.textContent
      .replaceAll("\u00c2", "")
      .split(/[\u00b7\u2022]/u)
      .map((label) => label.trim())
      .filter(Boolean);
    if (labels.length < 2) return;
    stack.textContent = "";
    labels.forEach((label) => {
      const tag = document.createElement("span");
      tag.className = "tech-tag";
      tag.textContent = label;
      stack.append(tag);
    });
  });

  document.querySelectorAll(".telemetry-card img").forEach((image) => {
    const card = image.closest(".telemetry-card");
    const fallback = card.querySelector(".telemetry-fallback");
    const showImage = () => {
      card.classList.remove("is-loading");
      card.classList.add("is-loaded");
    };
    const showFallback = () => {
      card.classList.remove("is-loading", "is-loaded");
      image.hidden = true;
      fallback.hidden = false;
    };
    image.addEventListener("load", showImage, { once: true });
    image.addEventListener("error", showFallback, { once: true });
    if (image.complete) {
      image.naturalWidth ? showImage() : showFallback();
    }
  });

  const year = document.querySelector("#current-year");
  if (year) year.textContent = String(new Date().getFullYear());

  const contactForm = document.querySelector(".contact-form");
  const contactStatus = document.querySelector("#contact-status");
  if (contactForm && contactStatus) {
    const fields = [...contactForm.querySelectorAll("input[required], textarea[required]")];
    const showFieldState = (field, invalid) => {
      const error = document.querySelector(`#${field.id}-error`);
      field.setAttribute("aria-invalid", String(invalid));
      if (error) error.hidden = !invalid;
    };

    contactForm.addEventListener("invalid", (event) => {
      if (fields.includes(event.target)) showFieldState(event.target, true);
    }, true);
    contactForm.addEventListener("input", (event) => {
      if (fields.includes(event.target) && event.target.checkValidity()) {
        showFieldState(event.target, false);
      }
    });
    contactForm.addEventListener("submit", async (event) => {
      event.preventDefault();
      const invalidField = fields.find((field) => !field.checkValidity());
      if (invalidField) {
        showFieldState(invalidField, true);
        invalidField.focus();
        return;
      }

      const submitButton = contactForm.querySelector("[type='submit']");
      const originalButtonText = submitButton.textContent;
      submitButton.disabled = true;
      submitButton.textContent = "Sending...";
      contactForm.setAttribute("aria-busy", "true");
      contactStatus.hidden = true;
      contactStatus.removeAttribute("data-state");
      contactStatus.setAttribute("role", "status");

      try {
        const payload = new URLSearchParams(new FormData(contactForm)).toString();
        const response = await fetch("/", {
          method: "POST",
          headers: { "Content-Type": "application/x-www-form-urlencoded" },
          body: payload,
        });
        if (!response.ok) throw new Error("The form endpoint returned an error.");

        contactForm.reset();
        fields.forEach((field) => showFieldState(field, false));
        contactStatus.textContent = "Message sent. Thanks for reaching out. I'll be in touch soon.";
        contactStatus.dataset.state = "success";
      } catch (error) {
        contactStatus.textContent = "Your message could not be sent right now. Please email koushik.d.ram@gmail.com instead.";
        contactStatus.dataset.state = "error";
        contactStatus.setAttribute("role", "alert");
      } finally {
        contactStatus.hidden = false;
        contactStatus.focus();
        submitButton.disabled = false;
        submitButton.textContent = originalButtonText;
        contactForm.removeAttribute("aria-busy");
      }
    });
  }

  const heroImage = document.querySelector(".cover img");
  if (heroImage && !reduceMotion.matches && matchMedia("(hover: hover) and (pointer: fine)").matches) {
    let frame = 0;
    let point = { x: 0, y: 0 };
    const updateParallax = () => {
      frame = 0;
      heroImage.style.setProperty("--parallax-x", `${point.x}px`);
      heroImage.style.setProperty("--parallax-y", `${point.y}px`);
    };
    document.querySelector(".cover").addEventListener("pointermove", (event) => {
      const bounds = event.currentTarget.getBoundingClientRect();
      point = {
        x: ((event.clientX - bounds.left) / bounds.width - 0.5) * -5,
        y: ((event.clientY - bounds.top) / bounds.height - 0.5) * -4,
      };
      if (!frame) frame = requestAnimationFrame(updateParallax);
    });
    document.querySelector(".cover").addEventListener("pointerleave", () => {
      point = { x: 0, y: 0 };
      if (!frame) frame = requestAnimationFrame(updateParallax);
    });
  }
})();
