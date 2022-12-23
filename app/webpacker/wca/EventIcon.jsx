import React from 'react';
import events from 'wca/events.js.erb';

const EventIcon = ({ id }) => (
  <span className={`cubing-icon event-${id}`}></span>
);

export default EventIcon;
