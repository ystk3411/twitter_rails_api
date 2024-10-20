# frozen_string_literal: true

class Api::V1::Users::RegistrationsController < DeviseTokenAuth::RegistrationsController
  private

  def sign_up_params
    params.require(:registration).permit(:email, :password, :password_confirmation, :name)
  end
end
