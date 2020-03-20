import React from 'react'
import ReactDOM from 'react-dom'
import SubmitResult from './SubmitResult'

afs.initSubmitResult = (competitionId) => {
  ReactDOM.render(
    <SubmitResult id="foo" competitionId={competitionId} />,
    document.getElementById('competition-results-area'),
  )
};
