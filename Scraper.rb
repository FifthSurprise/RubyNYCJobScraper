require 'nokogiri'
require 'open-uri'
require 'pry'

@companyList = []


def scrapeJobs
  page = Nokogiri::HTML(open("http://nytm.org/made-in-nyc/"))
  companiesData = page.css("article ol li")
  companiesData.each do |companyData|
    if companyData.css("a").length >1
      @companyList.push(Company.new(companyData.css("a")[0],companyData.css("a")[1]))
    end
    #binding.pry
  end
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

@companyList.each do |company|
  puts "#{company.name} is hiring at #{company.jobpage}"
end
