import React, { useEffect } from 'react';

const getInputs = container => {
  return Array.from(container.querySelectorAll('input, button')).filter(
    input => !input.disabled
  );
};

export const useKeyNavigation = container => {
  useEffect(() => {
    if (!container) return;
    const handleKeyPress = event => {
      if (event.key === 'Escape') {
        event.target.blur && event.target.blur();
        return;
      }
      if (
        ['ArrowUp', 'ArrowDown'].includes(event.key) &&
        container.querySelector('[aria-expanded="true"]')
      ) {
        /* Don't interrupt navigation within competitor select list. */
        return;
      }
      if (!['ArrowUp', 'ArrowDown', 'Enter', 'Tab'].includes(event.key)) return;
      if (['ArrowUp', 'ArrowDown'].includes(event.key)) {
        /* Prevent page scrolling. */
        event.preventDefault();
      }
      if (event.target.tagName === 'INPUT') {
        /* Blur the current input first, as it may affect which fields are disabled. */
        event.target.blur();
      }
      /* Let Tab be handled as usually. */
      if (event.key === 'Tab') return;
      /* Other handlers may change which fields are disabled, so let them run first. */
      setTimeout(() => {
        const inputs = getInputs(container);
        const index = inputs.findIndex(input => event.target === input);
        if (index === -1) return;
        const mod = n => (n + inputs.length) % inputs.length;
        if (event.key === 'ArrowUp') {
          const previousElement = inputs[mod(index - 1)];
          previousElement.focus();
          previousElement.select && previousElement.select();
        } else if (
          event.key === 'ArrowDown' ||
          (event.target.tagName === 'INPUT' && event.key === 'Enter')
        ) {
          const nextElement = inputs[mod(index + 1)];
          nextElement.focus();
          nextElement.select && nextElement.select();
        }
      }, 0);
    };
    container.addEventListener('keydown', handleKeyPress);
    return () => container.removeEventListener('keydown', handleKeyPress);
  }, [container]);

  useEffect(() => {
    if (!container) return;
    const handleKeyPress = event => {
      if (
        ['ArrowUp', 'ArrowDown', 'Enter'].includes(event.key) &&
        event.target === document.body
      ) {
        const [firstInput] = getInputs(container);
        if (firstInput) {
          firstInput.focus();
          firstInput.select();
        }
      }
    };
    window.addEventListener('keydown', handleKeyPress);
    return () => window.removeEventListener('keydown', handleKeyPress);
  }, [container]);
};
