import React, { Fragment, useState } from 'react';
import ListGroup from 'react-bootstrap/ListGroup';
import events from 'wca/events.js.erb';
import formats from 'wca/formats.js.erb';
import Row from 'react-bootstrap/Row';
import Col from 'react-bootstrap/Col';
import cn from 'classnames';

import { resultsListUrl, destroyResultUrl } from 'requests/routes.js.erb';
import { wcaProfileUrl } from 'afs/url_utils.js.erb';
import { loadableComponent } from 'requests/loadable';
import {
  formatAttemptResult,
} from 'wca/attempts';
import { trimTrailingZeros } from 'wca/utils';
import I18n from 'i18n-for-js/index.js.erb';

import Loading from './Loading'
import CountryFlag from 'wca/CountryFlag'
import DeleteButton from 'requests/DeleteButton';

const classNameForRank = rank => {
  switch (rank) {
    case 1:
      return "gold";
    case 2:
      return "silver";
    case 3:
      return "bronze";
  }
  return "";
};

const ListHeader = ({
  format,
  computeAverage
}) => {
  const mainField = format.sort_by === "single" ?
    I18n.t("online_competitions.submit.best")
    : I18n.t("online_competitions.submit.average");
  const otherField = format.sort_by === "single" ?
    I18n.t("online_competitions.submit.average")
    : I18n.t("online_competitions.submit.best");
  return (
    <ListGroup.Item>
      <Row>
        <Col xs={1}>
          #
        </Col>
        <Col xs={11}>
          <Row>
            <Col xs={12} md={4} lg={2}>
              <>
                <span className="font-weight-bold mr-3">
                  {mainField}
                </span>
              </>
              {computeAverage && (
                <span>({otherField})</span>
              )}
            </Col>
            <Col xs={12} md={8} lg={10}>
              <span className="text-dark">
                {I18n.t("online_competitions.show_results.results")}
              </span>
            </Col>
          </Row>
        </Col>
      </Row>
    </ListGroup.Item>
  );
};

const ResultItem = ({
  result,
  format,
  canManageResults,
  computeAverage
}) => {
  const mainField = format.sort_by === "single" ? "best" : "average";
  const otherField = format.sort_by === "single" ? "average" : "best";
  return (
    <ListGroup.Item className={classNameForRank(result.pos)}>
      <Row>
        <Col xs={2} md={1} className="d-flex flex-column justify-content-center">
           <div>{result.pos}</div>
        </Col>
        <Col xs={10} md={11}>
          <Row>
            <Col xs={8} md={4} lg={3}>
              <span className="mr-3">
                {result.user.wca_id ? (
                  <a
                    href={wcaProfileUrl(result.user.wca_id)}
                    target="_blank"
                    className="text-dark"
                  >
                    {result.user.name}
                  </a>
                ) : (
                  <span className="text-dark">{result.user.name}</span>
                )}
              </span>
            </Col>
            <Col xs={4} md={8} lg={9} className="d-flex justify-content-between">
              <CountryFlag iso2={result.user.country_iso2} />
              {canManageResults && (
                <DeleteButton url={destroyResultUrl(result.id)} />
              )}
            </Col>
            <Col xs={12} md={4} lg={2}>
              <>
                <span className="font-weight-bold mr-3">
                  {formatAttemptResult(result[mainField], result.event_id, mainField == "average")}
                </span>
              </>
              {computeAverage && (
                <span>
                  ({formatAttemptResult(result[otherField], result.event_id, otherField == "average")})
                </span>
              )}
            </Col>
            {result.attempts.map((a, index) => (
              <Col
                key={index}
                xs={4} md={2}
                lg={result.event_id === "333mbf" ? 2 : 1}
                className="text-dark"
              >
                {formatAttemptResult(a, result.event_id)}
              </Col>
            ))}
          </Row>
        </Col>
      </Row>
    </ListGroup.Item>
  );
};

const ResultsList = loadableComponent(({
  id,
  canManageResults,
  loadedState
}) => {
  const { eventId, competitionId } = id;
  const wcaEvent = events.byId[eventId];
  const format = formats.byId[wcaEvent.preferred_format];
  const solveCount = format.expected_solve_count;
  const computeAverage =
    [3, 5].includes(solveCount) && eventId !== '333mbf';
  return (
    <>
      {loadedState ? (
        <ListGroup>
          <ListHeader key="header"
            computeAverage={computeAverage}
            format={format}
          />
          {trimTrailingZeros(loadedState).map((result, index) => (
            <ResultItem
              key={index}
              result={result}
              computeAverage={computeAverage}
              format={format}
              canManageResults={canManageResults}
            />
          ))}
          {loadedState.length === 0 && (
            <ListGroup.Item key="none">
              Pas de résultat.
            </ListGroup.Item>
          )}
        </ListGroup>
      ) : (
        <Loading msg="Loading results" />
      )}
    </>
  );
}, resultsListUrl);

export default ResultsList;
