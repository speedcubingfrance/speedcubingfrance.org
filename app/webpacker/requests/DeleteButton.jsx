import React from 'react';
import Button from 'react-bootstrap/Button';
import FAIcon from 'wca/FAIcon';

// Return a delete link based on rails ujs
const DeleteButton = ({ url }) =>
  <Button
    variant="danger"
    href={url}
    data-method="delete"
    data-confirm="Êtes-vous sûr(e) de vouloir supprimer cet objet ?"
  >
    <FAIcon id="trash" />
  </Button>;

export default DeleteButton;
