class Rack::Attack
  Rack::Attack.throttle("ip", limit: 10, period: 1) do |req|
    req.ip
  end

  Rack::Attack.throttle("login_ip", limit: 7, period: 5.minutes) { |req|
    req.ip if req.post? && req.path == "/users/sign_in"
    too_many_login_tries_message(req)
  }

  Rack::Attack.throttle("login_email", limit: 7, period: 5.minutes) { |req|
    req.params["email"].presence if req.post? && req.path == "/users/sign_in"
    too_many_login_tries_message(req)
  }

  private

  def too_many_login_tries_message(req)
    Rack::Attack.throttled_callback = lambda do |_env|
      [
        403,
        { "Content-Type" => "text/plain" },
        [ "You've tried to log in too many times. \
          Your account has been locked for 5 minutes, after which you can try again." ]
      ]
    end
  end
end
