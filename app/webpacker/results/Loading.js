import React from 'react';
import Spinner from 'react-bootstrap/Spinner';

const Loading = ({ msg }) => (
  <div>
    <Spinner animation="border" variant="success">
    </Spinner>
    <div>{msg}</div>
  </div>
);

export default Loading;
