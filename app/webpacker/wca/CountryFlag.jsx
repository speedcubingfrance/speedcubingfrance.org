import React from 'react';

const CountryFlag = ({ iso2 }) => (
  <span className={`flag-icon flag-icon-${iso2}`}></span>
);

export default CountryFlag;
