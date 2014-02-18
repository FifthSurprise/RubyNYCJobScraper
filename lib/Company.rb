require_relative "../config/environment"
class Company
  attr_accessor :companyName, :companyURL, :jobURL
  ALL=[]
  def initialize (url, jobpage)
    @companyName= url.text
    @companyURL = url['href']
    @jobURL = jobpage['href']
    ALL<<self
  end

  def self.create_table
    DB.execute("CREATE TABLE IF NOT EXISTS companies (id integer primary key autoincrement,
      companyName text, companyURL text, jobURL text)")
  end

  def save
    if validURL?(@companyURL)&&validURL?(@jobURL)
      puts "Attempting to save #{@companyName}."
      puts "URL is #{@jobURL} and #{companyURL}"
      DB.execute("INSERT INTO companies (companyName,companyURL, jobURL) values(?,?,?)",
                 @companyName,@companyURL, @jobURL)
    end
  end

  #Catches any url with a status code and returns false instead.  Otherwise returns true
  def validURL? (url)
    begin  Timeout::timeout(5){open(url,:read_timeout => 3)}
    rescue
      return false
    end
    return true
  end
end
