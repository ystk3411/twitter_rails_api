# frozen_string_literal: true

module Api
  module V1
    module Users
      class RegistrationsController < DeviseTokenAuth::RegistrationsController
        private

        def sign_up_params
          params.require(:registration).permit(:email, :password, :password_confirmation, :name)
        end
      end
    end
  end
end
