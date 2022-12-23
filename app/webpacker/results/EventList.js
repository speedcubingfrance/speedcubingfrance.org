import React from 'react';
import events from 'wca/events.js.erb';
import Nav from 'react-bootstrap/Nav';
import OverlayTrigger from 'react-bootstrap/OverlayTrigger';
import Tooltip from 'react-bootstrap/Tooltip';
import EventIcon from 'wca/EventIcon';
import cn from 'classnames';

const EventList = ({ onClick, activeId }) => {
  return (
    <Nav
      fill
      activeKey={activeId}
      variant="pills"
      onSelect={onClick}
    >
      {events.official.map(e => (
        <Nav.Item key={e.id}>
          <OverlayTrigger
            placement="top"
            overlay={
              <Tooltip>
                {events.localizedName(events.byId[e.id])}
              </Tooltip>
            }
          >
            <Nav.Link eventKey={e.id}
               className={cn({ "active": e.id === activeId })}>
              <EventIcon id={e.id} />
            </Nav.Link>
          </OverlayTrigger>
        </Nav.Item>
      ))}
    </Nav>
  );
};

export default EventList;
