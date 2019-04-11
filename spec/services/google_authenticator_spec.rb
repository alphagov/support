describe GoogleAuthenticator do
  context "everything's fine" do
    it "doesn't error, auth issues are caught by the slug fetcher" do
      ENV["google_client_id"] = "fake_id"
      ENV["google_client_secret"] = "fake_secret"
      authenticator = GoogleAuthenticator.new(ClientSecretsLoader.load)
      expect(authenticator.auth_client.client_id).to eq("fake_id")
      expect(authenticator.auth_client.client_secret).to eq("fake_secret")
      ENV.delete("google_client_id")
      ENV.delete("google_client_secret")
    end
  end
  context "environment variables are not set" do
    it "raises an argument error" do
      expect { GoogleAuthenticator.new(ClientSecretsLoader.load) }.to raise_error(ArgumentError)
    end
  end
end
