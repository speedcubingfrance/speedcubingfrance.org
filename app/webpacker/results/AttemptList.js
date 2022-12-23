import React from 'react';
import Col from 'react-bootstrap/Col';
import Row from 'react-bootstrap/Row';

import {
  formatAttemptResult,
} from 'wca/attempts';
import { setAt } from 'wca/utils';
import { best, average } from 'wca/stats';
import AttemptField from 'wca-live/AttemptField/AttemptField';
import I18n from 'i18n-for-js/index.js.erb';

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
    <Row>
      {attempts.map((attempt, index) => (
        <Col xs={12} className="mb-3" key={index}>
          <AttemptField
            eventId={eventId}
            label={I18n.t("online_competitions.submit.attempt", {n: index + 1})}
            initialValue={attempt}
            onValue={value => setAttempts(setAt(attempts, index, value)) }
          />
        </Col>
      ))}
      <Col xs={6}>
        <b>{I18n.t("online_competitions.submit.best")}</b>: {formatAttemptResult(best(attempts), eventId)}
      </Col>
      <Col xs={6}>
        {computeAverage && (
          <>
            <b>{I18n.t("online_competitions.submit.average")}</b>:{' '}
            {formatAttemptResult(
              average(attempts, eventId, solveCount),
              eventId,
              true
            )}
          </>
        )}
      </Col>
    </Row>
  );
};

export default AttemptList;
