class Rack::Attack
  Rack::Attack.throttle("ip", limit: 10, period: 1) do |req|
    req.ip
  end

<<<<<<< HEAD
  Rack::Attack.throttle("login_ip", limit: 5, period: 5.min) { |req|
    req.ip if req.post? && req.path == "/users/sign_in"
  }

  Rack::Attack.throttle("login_email", limit: 5, period: 5.min) { |req|
=======
  Rack::Attack.throttle("login_ip", limit: 5, period: 5.minutes) { |req|
    req.ip if req.post? && req.path == "/users/sign_in"
  }

  Rack::Attack.throttle("login_email", limit: 5, period: 5.minutes) { |req|
>>>>>>> security-upgrades
    req.params["email"].presence if req.post? && req.path == "/users/sign_in"
  }
end
