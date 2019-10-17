require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    output = []
    doc = Nokogiri::HTML(open(index_url))
    student = doc.css('div.card-text-container')

    student.each { |student|
      name = student.css('h4.student-name').text
      location = student.css('p.student-location').text
      url = student.parent.first[1]
      output << {
        :name => name,
        :location => location,
        :profile_url => url,
      }
    }

    output
  end

  def self.scrape_profile_page(profile_url)
    html = open(profile_url)
  profiles = Nokogiri::HTML(html)

    student_hash  = {}
    links = profiles.css(".social-icon-container a").map {|anchor_tag| anchor_tag.attribute("href").value}
    #binding.pry
    links.each do |link|
      if link.include?("twitter")
        student_hash[:twitter] = link
      elsif link.include?("github")
        student_hash[:github] = link
      elsif link.include?("linkedin")
        student_hash[:linkedin] = link
      else 
        student_hash[:blog] = link
      end
    end

    student_hash[:profile_quote] = profiles.css(".profile-quote").text if profiles.css(".profile-quote")
    student_hash[:bio] = profiles.css(".description-holder p").text if profiles.css(".description-holder p")
    student_hash
  end

end

