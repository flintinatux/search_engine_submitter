require 'search_engine_submitter'

describe SearchEngineSubmitter do

  let(:sitemap_url) { 'http://testdomain.com/sitemap.xml' }
  let(:bad_url) { 'htt://somedomain.a' }

  shared_examples "a submitter" do
    it "should submit a good url" do
      response = subject.submit_sitemap_url sitemap_url, :to => search_engine
      response.status.should eq ["200", "OK"]
      response = URI(sitemap_url).submit_sitemap :to => search_engine
      response.status.should eq ["200", "OK"]
    end
  end
  
  describe "submit sitemap url" do
    engines = [:google, :yahoo, :bing]
    engines.each do |engine|
      describe "to #{engine.to_s}" do
        let(:search_engine) { engine }
        it_should_behave_like 'a submitter'

        if engine == :google
          it "should raise error for bad url" do
            expect { subject.submit_sitemap_url bad_url, :to => search_engine }.to raise_error(SearchEngineSubmitter::InvalidSitemapError)
          end
        end
      end
    end
  end
end