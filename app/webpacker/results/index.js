import React from 'react'
import ReactDOM from 'react-dom'
import SubmitResult from './SubmitResult'
import ShowResult from './ShowResult'

afs.initSubmitResult = (competitionId) => {
  ReactDOM.render(
    <SubmitResult id="foo" competitionId={competitionId} />,
    document.getElementById('competition-results-area'),
  )
};

afs.initShowResult = (competitionId) => {
  ReactDOM.render(
    <ShowResult id="foo" competitionId={competitionId} />,
    document.getElementById('competition-results-area'),
  )
};
