require 'search_engine_submitter'

RSpec::Matchers.define :be_ok do
  match do |responses|
    responses.each { |r| r.status == ["200", "OK"] }
  end
end

describe SearchEngineSubmitter do

  let(:sitemap_url) { 'http://testdomain.com/sitemap.xml' }
  let(:bad_url) { 'htt://somedomain.a' }

  before(:all) do
    @submitter = SearchEngineSubmitter::Submitter.new
    @uri = URI(sitemap_url)
  end

  shared_examples "a Submitter object" do
    it "should submit a good url" do
      responses = @submitter.submit_sitemap_url sitemap_url
      responses.should be_ok
    end

    it "should submit a good URI" do
      responses = @submitter.submit_sitemap_url @uri
      responses.should be_ok
    end
  end

  describe "with object methods" do
    engines = [:google, :yahoo, :bing]
    describe "to all three engines" do
      before { @submitter = SearchEngineSubmitter::Submitter.new(:engines => engines) }
      it_should_behave_like 'a Submitter object'
    end

    engines.each do |engine|
      describe "to only #{engine.to_s}" do
        before { @submitter.engines = engine }
        it_should_behave_like 'a Submitter object'

        if engine == :google
          it "should raise error for bad url" do
            expect { @submitter.submit_sitemap_url bad_url }.to raise_error(SearchEngineSubmitter::InvalidSitemapError)
          end
        end
      end
    end

    it "should work with RSS alias method" do
      responses = @submitter.submit_rss_url sitemap_url
      responses.should be_ok
    end
  end

  describe "with URI mixin methods" do
    describe "to all three engines" do
      it "should submit a good URI" do
        responses = @uri.submit_sitemap
        responses.should be_ok
      end
    end

    engines = [:google, :yahoo, :bing]
    engines.each do |engine|
      describe "to only #{engine.to_s}" do
        it "should submit a good URI" do
          responses = @uri.submit_sitemap :to => engine
          responses.should be_ok
        end
      end
    end

    it "should work with RSS alias method" do
      responses = @uri.submit_rss
      responses.should be_ok
    end
  end
end