module AuthenticationControllerHelpers
  def login_as(user)
    @user = user
    request.env['warden'] = double(
      authenticate!: true,
      authenticated?: true,
      user: user
    )
  end

  def login_as_an_authorised_user
    @user = double(:user,
      name: "A",
      email: "a@b.com",
      remotely_signed_out?: false,
      has_permission?: true
    )
    request.env['warden'] = double(
      user: @user,
      authenticate!: true,
      authenticated?: true,
    )
  end
end

RSpec.configuration.include AuthenticationControllerHelpers, type: :controller
