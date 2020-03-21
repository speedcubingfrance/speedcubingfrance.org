import React, { useState } from 'react';

import { dnfKeys, dnsKeys } from '../keybindings';
import { formatAttemptResult } from '../../../wca/attempts';

const validateFmResult = number => {
  if (number > 80) return -1;
  return number;
};

const FmField = ({ initialValue, onValue, ...props }) => {
  const [prevInitialValue, setPrevInitialValue] = useState(null);
  const [value, setValue] = useState(initialValue);

  /* Sync local value when initial value changes. See AttemptField for detailed description. */
  if (prevInitialValue !== initialValue) {
    setValue(initialValue);
    setPrevInitialValue(initialValue);
  }

  return (
    <div>
        <label>{props.label}</label>
      <input
        type="text"
        className="form-control"
        value={formatAttemptResult(value, "333fm")}
        onKeyPress={event => {
          if (dnfKeys.includes(event.key)) {
            setValue(-1);
            event.preventDefault();
          } else if (dnsKeys.includes(event.key)) {
            setValue(-2);
            event.preventDefault();
          }
        }}
        onChange={event => {
          const newValue = parseInt(event.target.value.replace(/\D/g, ''), 10) || 0;
          setValue(newValue);
        }}
        onBlur={() => {
          onValue(validateFmResult(value));
          /* Once we emit the change, reflect the initial state. */
          setValue(initialValue);
        }}
      />
    </div>
  );
};

export default FmField;
