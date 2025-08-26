//= require govuk_publishing_components/dependencies
//= require govuk_publishing_components/lib/cookie-functions
//= require ./domain-config

window.GOVUK.approveAllCookieTypes()
window.GOVUK.cookie('cookies_preferences_set', 'true', { days: 365 })
