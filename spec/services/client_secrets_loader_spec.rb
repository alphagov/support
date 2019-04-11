describe ClientSecretsLoader do
  context "everything's fine" do
    it "loads the secrets" do
      ENV["google_client_id"] = "totaly_real_client_id"
      ENV["google_client_secret"] = "equally_real_secret"
      expect(ClientSecretsLoader.load.client_id).to eq("totaly_real_client_id")
      expect(ClientSecretsLoader.load.client_secret).to eq("equally_real_secret")
      ENV.delete("google_client_id")
      ENV.delete("google_client_secret")
    end
  end
  context "there's no /config/client_secrets.json.erb" do
    it "raises an Argument Error" do
      allow(File).to receive(:exist?).and_return(false)
      expect { ClientSecretsLoader.load }.to raise_error(ArgumentError)
    end
  end
  context "the required environment variables are not set" do
    it "leaves the fields with default values and allows the GoogleAuthenticator to catch the issue" do
      expect(ClientSecretsLoader.load.client_id).to eq("client_id")
      expect(ClientSecretsLoader.load.client_secret).to eq("client_secret")
    end
  end
end
