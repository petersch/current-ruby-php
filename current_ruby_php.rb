require 'rubygems'
require 'mechanize'

def ruby_current version, patch, url = 'https://www.ruby-lang.org/en/downloads/'
  begin
    Mechanize.new.get(url).links.find do |link|
      match = /Ruby #{version}-p(\d+)/.match(link.text)
      if match && match[1].to_i > patch
        return link.href
      end
    end
  rescue Exception
    return nil
  end
end

def php_current version, patch, url = 'http://www.php.net/downloads.php'
  begin
    Mechanize.new.get(url).links_with(:href => /get\/php.*tar\.gz\/from/).each do |link|
      link_version = link.href[/\d+\.\d+\.\d+/]
      link_patch = link_version[/\d*$/].to_i
      if link_version[/^\d+\.\d+/] == version && link_patch > patch
        return link.click.links_with(:text => /cz1.php.net/).first.href
      end
    end
    return nil
  rescue Exception
    return nil
  end
end

puts ruby_current('2.0.0', 353)
puts php_current('5.5', 7)