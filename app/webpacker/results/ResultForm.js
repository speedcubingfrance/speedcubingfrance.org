import React, { useState, useEffect, useRef } from 'react';
import { loadableComponent } from 'requests/loadable';
import { loadResultUrl } from 'requests/routes.js.erb';
import formats from 'wca/formats.js.erb';
import { times, trimTrailingZeros } from 'wca/utils';
import { best, average } from 'wca/stats';
import { useKeyNavigation } from 'wca-live/navigation';
import Row from 'react-bootstrap/Row';
import Col from 'react-bootstrap/Col';
import Spinner from 'react-bootstrap/Spinner';
import Button from 'react-bootstrap/Button';
import isEqual from 'lodash/isEqual';

import I18n from 'i18n-for-js/index.js.erb';
import AttemptList from './AttemptList';
import ScramblesDisplay from './ScramblesDisplay';
import SubmissionHelp from './SubmissionHelp';
import { ErrorList } from 'requests/Lists';

const ResultForm = ({
  id,
  originalResult,
  saving,
  saveState,
  userData
}) => {
  const [attempts, setAttempts] = useState([]);
  const [savedResult, setSavedResult] = useState(originalResult);
  const [errors, setErrors] = useState([]);
  const [initFocus, setInitFocus] = useState(false);
  const rootRef = useRef(null);
  const eventId = id.eventId
  const competitionId = id.competitionId
  const solveCount = originalResult.format_id ?
    formats.byId[originalResult.format_id].expected_solve_count : 0;

  const resetState = res => {
    setErrors([]);
    setAttempts(
      times(solveCount, index =>
        (res.attempts && res.attempts[index]) || 0)
    );
    setSavedResult(res);
    setInitFocus(false);
  };

  useEffect(() => {
    if (!rootRef.current) return;
    if (initFocus) return;
    const firstAttemptInput = rootRef.current.getElementsByTagName('input')[0];
    if (!firstAttemptInput) return;
    setInitFocus(true);
    setTimeout(() => {
      firstAttemptInput.focus();
      firstAttemptInput.select();
    }, 0);
  });

  useEffect(() => {
    resetState(originalResult);
  }, [originalResult]);

  const toRequestData = clear => {
    const resAttempts = clear ? [0, 0, 0, 0, 0] : attempts;
    const res = {
      best: best(resAttempts),
      average: average(resAttempts, eventId, solveCount),
      attempts: resAttempts,
    }
    resAttempts.map((a, index) => res[`value${index+1}`] = a);
    return {
      competition_id: competitionId,
      event_id: eventId,
      result: res,
    };
  };

  useKeyNavigation(rootRef.current);

  const hasChanges = () => {
    return !isEqual(trimTrailingZeros(savedResult.attempts), trimTrailingZeros(attempts));
  };

  const mayDelete = () => {
    return trimTrailingZeros(savedResult.attempts).length !== 0;
  };

  const saveResult = clear => {
    const res = toRequestData(clear);
    const newSaved = {
      ...savedResult,
      best: res.result.best,
      average: res.result.average,
      attempts: res.result.attempts,
    };
    saveState(res, response => {
      if (response.errors) {
        setErrors(response.errors);
      } else {
        resetState(newSaved);
      }
    });
  };

  return (
    <>
      <Row ref={rootRef}>
        {originalResult.scrambles_data.scrambles && (
          <Col xs={12} className="mb-3">
            <ScramblesDisplay
              scramblesData={originalResult.scrambles_data}
              eventId={eventId}
            />
          </Col>
        )}
        <Col xs={12} md={6} className="mb-3">
          <AttemptList
            attempts={attempts}
            setAttempts={setAttempts}
            eventId={eventId}
            savedResult={savedResult}
            solveCount={solveCount}
          />
          <div className="mt-3">
          <div className="d-flex justify-content-center mb-2">
            <Button size="lg"
              variant="outline-success"
              className="mr-3"
              disabled={!hasChanges() || saving}
              onClick={() => saveResult(false)}
            >
              {saving ? (
                <Spinner role="status" animation="border">
                  <span className="sr-only">Saving...</span>
                </Spinner>
              ) : (
                <>{I18n.t("online_competitions.submit.save")}</>
              )}
            </Button>
            <Button size="lg"
              variant="outline-danger"
              disabled={!mayDelete() || saving}
              onClick={() => saveResult(true)}
            >
              {saving ? (
                <Spinner role="status" animation="border">
                  <span className="sr-only">Saving...</span>
                </Spinner>
              ) : (
                <>{I18n.t("online_competitions.submit.delete")}</>
              )}
            </Button>
          </div>
          <p className="font-weight-bold">
            {I18n.t("online_competitions.submit.save_before_switch")}
          </p>
          {errors.length > 0 && (
            <div className="text-left">
              <ErrorList items={errors} />
            </div>
          )}
          </div>

        </Col>
        <Col xs={12} md={6} className="text-center d-flex flex-column">
          <SubmissionHelp />
        </Col>
      </Row>
    </>
  );
};

export default ResultForm;
