---
name: project-site-external-origins
description: External origins and JS reality of the static site, which drive the CloudFront CSP (response headers policy) in terraform/main.tf
metadata:
  type: project
---

As of 2026-10-17 the CloudFront CSP in terraform/main.tf allowlists only these external origins, found by scanning index.html/privacy.html/terms.html/style.css:
- https://cdnjs.cloudflare.com: Font Awesome 6.5.0 all.min.css (style-src) plus its relative webfonts (font-src)
- https://img-c.udemycdn.com: course thumbnail <img> tags in index.html (img-src)
- 'unsafe-inline' in style-src: the <style> blocks in privacy.html/terms.html

CLAUDE.md says "no JavaScript", but index.html has inline onclick handlers (goToSection, toggleMenu) that call functions defined nowhere (no <script> tag, no .js file). script-src 'self' blocks them, and they were already broken anyway.

**Why:** If the site adds new external assets (fonts, embeds, scripts), the CSP must be updated or they will break silently.
**How to apply:** When site content or the CSP changes, rescan the HTML/CSS for new origins. Do not add 'unsafe-inline' to script-src just to fix the dead onclick handlers. Fix them with a real self-hosted JS file instead.
