require 'search_engine_submitter'

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
      responses.each { |r| r.status.should eq ["200", "OK"] }
    end

    it "should submit a good URI" do
      responses = @submitter.submit_sitemap_url @uri
      responses.each { |r| r.status.should eq ["200", "OK"] }
    end
  end

  describe "with object methods" do
    describe "to all three engines" do
      it_should_behave_like 'a Submitter object'
    end

    engines = [:google, :yahoo, :bing]
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
      responses.each { |r| r.status.should eq ["200", "OK"] }
    end
  end

  shared_examples "a Submitter class" do
    it "should submit a good url" do
      responses = SearchEngineSubmitter.submit_sitemap_url sitemap_url, options
      responses.each { |r| r.status.should eq ["200", "OK"] }
    end

    it "should submit a good URI" do
      responses = SearchEngineSubmitter.submit_sitemap_url @uri, options
      responses.each { |r| r.status.should eq ["200", "OK"] }
    end
  end

  describe "with class/module methods" do
    describe "to all three engines" do
      let(:options) { Hash.new }
      it_should_behave_like 'a Submitter class'
    end

    engines = [:google, :yahoo, :bing]
    engines.each do |engine|
      describe "to only #{engine.to_s}" do
        let(:options) { { :to => engine } }
        it_should_behave_like 'a Submitter class'

        if engine == :google
          it "should raise error for bad url" do
            expect { SearchEngineSubmitter.submit_sitemap_url bad_url, options }.to raise_error(SearchEngineSubmitter::InvalidSitemapError)
          end
        end
      end
    end

    it "should work with RSS alias method" do
      responses = SearchEngineSubmitter.submit_rss_url sitemap_url
      responses.each { |r| r.status.should eq ["200", "OK"] }
    end
  end

  describe "with URI mixin methods" do
    describe "to all three engines" do
      let(:options) { Hash.new }
    end

    engines = [:google, :yahoo, :bing]
    engines.each do |engine|
      describe "to only #{engine.to_s}" do
        let(:options) { { :to => engine } }
        it "should submit a good URI" do
          responses = @uri.submit_sitemap options
          responses.each { |r| r.status.should eq ["200", "OK"] }
        end
      end
    end

    it "should work with RSS alias method" do
      responses = @uri.submit_rss
      responses.each { |r| r.status.should eq ["200", "OK"] }
    end
  end
end