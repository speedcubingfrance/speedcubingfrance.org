import React from 'react';
import Col from 'react-bootstrap/Col';

import {
  formatAttemptResult,
} from 'wca/attempts';
import { setAt } from 'wca/utils';
import { best, average } from 'wca/stats';
import AttemptField from 'wca-live/AttemptField/AttemptField';

const AttemptList = ({
  attempts,
  setAttempts,
  eventId,
  savedResult,
  solveCount,
}) => {
  const computeAverage =
    [3, 5].includes(solveCount) && eventId !== '333mbf';
  return (
    <>
      {attempts.map((attempt, index) => (
        <Col xs={12} className="mb-3" key={index}>
          <AttemptField
            eventId={eventId}
            label={`Essai ${index + 1}`}
            initialValue={attempt}
            onValue={value => setAttempts(setAt(attempts, index, value)) }
          />
        </Col>
      ))}
      <Col xs={6}>
        <b>Meileur</b>: {formatAttemptResult(best(attempts), eventId)}
      </Col>
      <Col xs={6}>
        {computeAverage && (
          <>
            <b>Moyenne</b>:{' '}
            {formatAttemptResult(
              average(attempts, eventId, solveCount),
              eventId,
              true
            )}
          </>
        )}
      </Col>
    </>
  );
};

export default AttemptList;
