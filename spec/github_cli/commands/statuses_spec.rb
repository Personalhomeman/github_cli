# frozen_string_literal: true

RSpec.describe GithubCLI::Commands::Statuses do
  let(:format) { {'format' => 'table'} }
  let(:user)   { 'peter-murach' }
  let(:repo)   { 'github_cli' }
  let(:sha)    { '7f86c1b73255d4409348d68eb75f7cbbc2aa5c74' }
  let(:api_class) { GithubCLI::Status }

  it "invokes status:list" do
    expect(api_class).to receive(:all).with(user, repo, sha, {}, format)
    subject.invoke "status:list", [user, repo, sha]
  end

  it "invokes status:create" do
    expect(api_class).to receive(:create).with(user, repo, sha, {}, format)
    subject.invoke "status:create", [user, repo, sha]
  end

  it "invokes status:create --state --target" do
    expect(api_class).to receive(:create).with(user, repo, sha,
      {'state' => 'pending', 'target_url' => 'http://ci.example.com'}, format)
    subject.invoke "status:create", [user, repo, sha], :state => 'pending',
      :target => "http://ci.example.com"
  end
end
