import React, { Fragment, useState } from 'react';
import events from 'wca/events';
import { loadableComponent } from 'requests/loadable';
import { selfInfoUrl } from 'requests/routes';

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
              <h3 className="mt-3">{wcaEvent.name}</h3>
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
        <Loading msg="Loading results" />
      )}
    </Fragment>
  );
}, selfInfoUrl);

export default SubmitResult;
