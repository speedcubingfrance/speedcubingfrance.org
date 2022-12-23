import React, { Fragment, useState } from 'react';
import events from 'wca/events.js.erb';
import { loadableComponent } from 'requests/loadable';
import { selfInfoUrl } from 'requests/routes.js.erb';
import I18n from 'i18n-for-js/index.js.erb';

import EventList from './EventList';
import ResultsList from './ResultsList';

const ShowResult = loadableComponent(({
  competitionId,
  loadedState
}) => {
  const [activeId, setActive] = useState("333");
  const wcaEvent = events.byId[activeId];
  return (
    <>
      <EventList activeId={activeId} onClick={setActive} />
      <h3 className="mt-3">
        {I18n.t("online_competitions.show_results.results_for", {event_name: I18n.t(`events.${wcaEvent.id}`)})}
      </h3>
      <ResultsList id={{eventId: activeId, competitionId: competitionId}}
        canManageResults={loadedState && loadedState.can_manage_online_comps}
      />
    </>
  );
}, selfInfoUrl);

export default ShowResult;
