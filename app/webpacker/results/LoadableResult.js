import React, { useState, useEffect } from 'react';
import { loadableComponent } from 'requests/loadable';
import { savableComponent } from 'requests/savable';
import { loadResultUrl, submitResultUrl } from 'requests/routes';

import Loading from './Loading'
import ResultForm from './ResultForm'

const LoadableResult = savableComponent(loadableComponent(({
  id,
  loadedState,
  saving,
  saveState,
  userData
}) => {
  return (
    <>
      {loadedState ? (
        <ResultForm
          id={id}
          originalResult={loadedState}
          userData={userData}
          saving={saving}
          saveState={saveState}
        />
      ) : (
        <Loading msg="Loading results" />
      )}
    </>
  );
}, loadResultUrl), submitResultUrl);
export default LoadableResult;
