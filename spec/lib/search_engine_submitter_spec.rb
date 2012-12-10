require 'search_engine_submitter'

describe SearchEngineSubmitter do

  let(:sitemap_url) { 'http://testdomain.com/sitemap.xml' }
  let(:bad_url) { 'htt://somedomain.a' }

  shared_examples "a submitter" do
    it "should submit a good url" do
      response = subject.submit_sitemap_url sitemap_url, :to => search_engine
      response.status.should eq ["200", "OK"]
    end

    it "should submit a good URI" do
      response = URI(sitemap_url).submit_sitemap :to => search_engine
      response.status.should eq ["200", "OK"]
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
        response = subject.submit_sitemap_url sitemap_url
        response.status.should eq ["200", "OK"]
      end

      it "should submit a good URI" do
        response = URI(sitemap_url).submit_sitemap
        response.status.should eq ["200", "OK"]
      end
    end
  end
end