Rails.application.config.middleware.use OmniAuth::Builder do
  provider :github, ENV["GITHUB_KEY"], ENV["GITHUB_SECRET"], provider_ignores_state: true
  # provider :github, ENV["GITHUB_KEY"], ENV["GITHUB_SECRET"], callback_path: "/peanut/auth/github/callback", provider_ignores_state: true
end
