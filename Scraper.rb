require 'nokogiri'
require 'open-uri'
require 'pry'

@companyList = []


def scrapeJobs
  page = Nokogiri::HTML(open("http://nytm.org/made-in-nyc/"))
  companiesData = page.css("article ol li")
  companiesData.each do |companyData|
    company = companyData.css("a")
    if company.length >1
      @companyList.push(Company.new(company[0],company[1]))
    end
    #binding.pry
  end
end

#Catches any url with a status code and returns false instead.  Otherwise returns true
def validURL? (url)
  begin open (url)
  rescue
    return false
  end
  return true
end

def cleanCompanies
  @companyList.select! {|company|validURL?(company.url)&&validURL?(company.jobpage)}
end

class Company
  def initialize (url, jobpage)
    @name= url.text
    @url = url['href']
    @jobpage = jobpage['href']
  end

  def name
    @name
  end

  def url
    @url
  end

  def jobpage
    @jobpage
  end
end

scrapeJobs
cleanCompanies

@companyList.each do |company|
  puts "#{company.name} is hiring at #{company.jobpage}"
end
