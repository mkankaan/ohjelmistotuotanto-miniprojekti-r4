function copyBibtex() {
    const el = document.getElementById('bibtex');
    const text = (el?.textContent || '').trim();

    // Prefer modern API when available in a secure context (HTTPS or localhost)
    const isLocalhost = /^(localhost|127\.0\.0\.1|::1)$/.test(location.hostname);
    const canUseModernAPI = !!(navigator.clipboard && (window.isSecureContext || isLocalhost));

    if (canUseModernAPI) {
      navigator.clipboard.writeText(text)
        .then(() => alert('Copied!'))
        .catch(err => {
          console.warn('Clipboard API failed, using fallback:', err);
          fallbackCopyText(text);
        });
    } else {
      // Plain HTTP (non-secure) or older browser → fallback
      fallbackCopyText(text);
    }
  }

  function fallbackCopyText(text) {
    // Create a temporary, off-screen <textarea>
    const ta = document.createElement('textarea');
    ta.value = text;

    // Make it non-disruptive
    ta.setAttribute('readonly', '');
    ta.style.position = 'fixed';
    ta.style.top = '-9999px';
    ta.style.left = '-9999px';

    document.body.appendChild(ta);

    // Select & copy
    ta.focus();
  };
