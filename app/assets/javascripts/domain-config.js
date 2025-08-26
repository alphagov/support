'use strict'
window.GOVUK = window.GOVUK || {}
window.GOVUK.vars = window.GOVUK.vars || {}
window.GOVUK.vars.extraDomains = [
  {
    name: 'production',
    domains: ['support.publishing.service.gov.uk'],
    initialiseGA4: true,
    id: 'GTM-P93SHJ4Z'
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
    id: 'GTM-P93SHJ4Z',
    auth: '8jHx-VNEguw67iX9TBC6_g',
    preview: 'env-50'
  }
]
