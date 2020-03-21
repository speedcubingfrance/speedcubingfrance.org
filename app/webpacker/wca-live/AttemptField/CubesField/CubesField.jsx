import React, { useState } from 'react';

const CubesField = ({ initialValue, onValue, ...props }) => {
  const [prevInitialValue, setPrevInitialValue] = useState(null);
  const [value, setValue] = useState(initialValue);

  /* Sync local value when initial value changes. See AttemptField for detailed description. */
  if (prevInitialValue !== initialValue) {
    setValue(initialValue);
    setPrevInitialValue(initialValue);
  }

  return (
    <div className="col-xs-12">
      <input
        type="text"
        className="form-control"
        value={value || ''}
        onChange={event => {
          const newValue = parseInt(event.target.value.replace(/\D/g, ''), 10) || 0;
          if (newValue <= 99) setValue(newValue);
        }}
        onBlur={() => {
          onValue(value);
          /* Once we emit the change, reflect the initial state. */
          setValue(initialValue);
        }}
      />
    </div>
  );
};

export default CubesField;
