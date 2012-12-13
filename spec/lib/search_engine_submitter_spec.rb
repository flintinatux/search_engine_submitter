require 'search_engine_submitter'

describe SearchEngineSubmitter do

  let(:sitemap_url) { 'http://testdomain.com/sitemap.xml' }
  let(:bad_url) { 'htt://somedomain.a' }

  shared_examples "a submitter" do
    it "should submit a good url" do
      responses = subject.submit_sitemap_url sitemap_url, :to => search_engine
      responses.each { |r| r.status.should eq ["200", "OK"] }
    end

    it "should submit a good URI" do
      responses = URI(sitemap_url).submit_sitemap :to => search_engine
      responses.each { |r| r.status.should eq ["200", "OK"] }
    end
  end
  
  describe "submit sitemap url" do
    engines = [:google, :yahoo, :bing]
    engines.each do |engine|
      describe "to only #{engine.to_s}" do
        let(:search_engine) { engine }
        it_should_behave_like 'a submitter'

        if engine == :google
          it "should raise error for bad url" do
            expect { subject.submit_sitemap_url bad_url, :to => search_engine }.to raise_error(SearchEngineSubmitter::InvalidSitemapError)
          end
        end
      end
    end

    describe "to all three search engines" do
      let(:search_engine) { engines }
      it_should_behave_like 'a submitter'
    end

    describe "with no :to option" do
      it "should submit a good url" do
        responses = subject.submit_sitemap_url sitemap_url
        responses.each { |r| r.status.should eq ["200", "OK"] }
      end

      it "should submit a good URI" do
        responses = URI(sitemap_url).submit_sitemap
        responses.each { |r| r.status.should eq ["200", "OK"] }
      end
    end

    describe "with RSS alias methods" do
      it "should submit a good url" do
        responses = subject.submit_rss_url sitemap_url
        responses.each { |r| r.status.should eq ["200", "OK"] }
      end

      it "should submit a good URI" do
        responses = URI(sitemap_url).submit_rss
        responses.each { |r| r.status.should eq ["200", "OK"] }
      end
    end

    describe "with new object format" do
      let(:submitter) { SearchEngineSubmitter::Submitter.new :url => sitemap_url }

      it "should submit a url" do
        engines.each do |engine|
          submitter.submit_sitemap :to => engine
        end
        submitter.submit_sitemap
      end
    end
  end
end