import React from 'react';
import I18n from 'i18n-for-js/index.js.erb';

const SubmissionHelp = () => (
  <>
    <h5>{I18n.t("subhelp.title")}</h5>
    <div className="text-justify">
      {I18n.t("subhelp.p1")}
      <ul>
        <li>{I18n.t("subhelp.ex1")}</li>
        <li>{I18n.t("subhelp.ex2")}</li>
      </ul>
      {I18n.t("subhelp.cents")}<br/>
      {I18n.t("subhelp.penalties")}
      <ul>
        <li>{I18n.t("subhelp.pen1")}</li>
        <li>{I18n.t("subhelp.pen2")}</li>
      </ul>
      <p>
        {I18n.t("subhelp.multihelp")}
        <br/>
        {I18n.t("subhelp.multiex")}<br/>
      </p>

      <p>
        {I18n.t("subhelp.enjoying")}
      </p>
    </div>
  </>
);

export default SubmissionHelp;
