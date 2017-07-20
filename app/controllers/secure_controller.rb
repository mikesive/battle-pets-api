class SecureController < ApplicationController
  before_action :authenticate!
end
