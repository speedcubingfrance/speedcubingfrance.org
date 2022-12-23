import React, { Fragment, useState } from 'react';
import events from 'wca/events.js.erb';
import { loadableComponent } from 'requests/loadable';
import { selfInfoUrl } from 'requests/routes.js.erb';
import I18n from 'i18n-for-js/index.js.erb';

import EventList from './EventList'
import Loading from './Loading'
import LoadableResult from './LoadableResult'
import NotSignedIn from 'requests/NotSignedIn'

const SubmitResult = loadableComponent(({
  competitionId,
  loadedState
}) => {
  const [activeId, setActive] = useState("333");
  const wcaEvent = events.byId[activeId];
  return (
    <Fragment>
      {loadedState ? (
        <Fragment>
          {loadedState.id ? (
            <Fragment>
              <EventList activeId={activeId} onClick={setActive} />
              <h3 className="mt-3 mb-3">
                {events.localizedName(wcaEvent)} -{' '}
                {loadedState.name}{' '}
                {loadedState.wca_id && (
                  <span>({loadedState.wca_id})</span>
                )}
              </h3>
              <LoadableResult
                id={{
                  eventId: wcaEvent.id,
                  competitionId: competitionId,
                }}
                userData={loadedState}
              />
            </Fragment>
          ) : (
            <NotSignedIn />
          )}
        </Fragment>
      ) : (
        <Loading msg={I18n.t("online_competitions.show_results.loading")} />
      )}
    </Fragment>
  );
}, selfInfoUrl);

export default SubmitResult;
