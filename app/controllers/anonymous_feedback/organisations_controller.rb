class AnonymousFeedback::OrganisationsController < AuthorisationController
  def show
    authorize! :read, :anonymous_feedback

    # FIXME: actually get actual feedback based on organisation
    @feedback = []
  end
end
