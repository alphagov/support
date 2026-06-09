'use strict'
window.GOVUK = window.GOVUK || {}
window.GOVUK.vars = window.GOVUK.vars || {}
window.GOVUK.vars.extraDomains = [
  {
    name: 'production',
    domains: ['support.publishing.service.gov.uk'],
    initialiseGA4: true,
    id: 'GTM-KHZP7S7Q'
  },
  {
    name: 'staging',
    domains: ['support.staging.publishing.service.gov.uk'],
    initialiseGA4: false
  },
  {
    name: 'integration',
    domains: ['support.integration.publishing.service.gov.uk'],
    initialiseGA4: true,
    id: 'GTM-KHZP7S7Q',
    auth: 'GoGeIsCL2PK9Dv50tgM6Lg',
    preview: 'env-172'
  }
]
