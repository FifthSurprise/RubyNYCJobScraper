require_relative "../config/environment"

class Scraper
  attr_accessor :companyList
  MADEINNYCURL = "http://nytm.org/made-in-nyc/"
  def initialize
    self.companyList=[]
  end
  def scrapeJobs
    page = Nokogiri::HTML(open(MADEINNYCURL))
    companiesData = page.css("article ol li")
    companiesData.each do |companyData|
      company = companyData.css("a")
      #If there are two links (implying hiring), add it to the list
      if company.length >1
        @companyList.push(Company.new(company[0],company[1]))
      end
    end
    # cleanCompanies
    @companyList
  end

  #Catches any url with a status code and returns false instead.  Otherwise returns true
  def validURL? (url)
    begin open (url)
    rescue
      return false
    end
    return true
  end

  #remove any company from the list that does not have a working job url
  def cleanCompanies
    @companyList.select! {|company|validURL?(company.companyURL)&&validURL?(company.jobURL)}
  end

end
# scrapeJobs
# companyList
# Company::ALL.each {|company| puts "#{company.name} is hiring at #{company.jobURL}"}
