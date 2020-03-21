import React from 'react';

import Alert from 'react-bootstrap/Alert';

const List = ({ items, style }) => {
  return (
    <Alert variant={style} role="alert">
      Oups, il y a au moins une erreur :
      <ul>
        {items.map((item, index) => <li key={index}>{item}</li>)}
      </ul>
    </Alert>
  );
};

export const ErrorList = props => <List {...props} style="danger" />;
export const InfoList = props => <List {...props} style="info" />;
