//= require accessible-autocomplete/dist/accessible-autocomplete.min.js

window.GOVUK = window.GOVUK || {}
window.GOVUK.Modules = window.GOVUK.Modules || {};

(function (Modules) {
  'use strict'

  function Autocomplete ($module) {
    this.$module = $module
  }

  Autocomplete.prototype.init = function () {
    const $select = this.$module

    window.accessibleAutocomplete.enhanceSelectElement({
      selectElement: $select,
      showAllValues: true
    })
  }

  Modules.Autocomplete = Autocomplete
})(window.GOVUK.Modules)
