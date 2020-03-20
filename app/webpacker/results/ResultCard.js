import React, { Fragment, useState } from 'react';

const ResultCard = ({
  wcaEvent,
  competitionId
}) => {
  return (
    <div>{wcaEvent.id} at {competitionId}</div>
  );
};

export default ResultCard;
