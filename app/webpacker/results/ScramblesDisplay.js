import React, { useState } from 'react';

import I18n from 'i18n-for-js/index.js.erb';
import Card from 'react-bootstrap/Card';

const LongScramblesList = ({
  scramblesData
}) => (
  <pre>
    {scramblesData.scrambles.map((s, index) => {
      return (
        <div key={index}>
          {I18n.t("online_competitions.submit.attempt", {n: index + 1})}<br/>
          {s}
          <hr/>
        </div>
      );
    })}
    {scramblesData.extras.map((s, index) => {
      return (
        <div key={index}>
          {I18n.t("online_competitions.submit.extra", {n: index + 1})}<br/>
          {s}
          <hr/>
        </div>
      );
    })}
  </pre>
);

const ScramblesDisplay = ({
  eventId,
  scramblesData
}) => {
  const [expanded, setExpanded] = useState(false);
  const headerAction = ev => {
    ev.preventDefault();
    ;
  };
  return (
    <Card className="scrambles-card">
      <Card.Header onClick={() => setExpanded(!expanded)} className="text-center">
        {I18n.t("online_competitions.submit.scrambles")}
      </Card.Header>
      {expanded && (
        <Card.Body>
          {(eventId === "333mbf" || eventId === "minx") ? (
            <LongScramblesList scramblesData={scramblesData} />
          ) : (
            <pre>
            {scramblesData.scrambles.join("\n")}
            <br/>Extras:<br/>
            {scramblesData.extras.join("\n")}
            </pre>
          )}
        </Card.Body>
      )}
    </Card>
  );
};

export default ScramblesDisplay;
