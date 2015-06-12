require "pageinfo/version"
require "uri"
require "typhoeus"
require "nokogiri"

module Pageinfo
  def self.detect(url)
    content = ["url", "status", "time", "title", "description", "keyword"].join(",")
    content << new_line

    @@no = 0
    @@main_host = get_host(URI.parse(url))
    scrapped_links, scrapped_urls = [url], [url]

    conn = Typhoeus.get(url)
    page = Nokogiri::HTML(conn.body)

    content << get_info(conn, page)
    content << new_line

    @links = get_page_links(page)
    while true do
      if link = @links.shift
        full_url = get_full_url(link)
        unless full_url.nil?
          if (scrapped_urls & [full_url, "#{full_url}/", "#{full_url}/#"]).empty?
            conn = Typhoeus.get(full_url)
            page = Nokogiri::HTML(conn.body)
            content << get_info(conn, page)
            content << new_line

            scrapped_links << link
            scrapped_urls << full_url

            new_links = get_page_links(page)
            new_links = new_links - @links
            new_links = new_links - scrapped_links
            @links = @links + new_links unless new_links.empty?
          end
        end
      else
        break;
      end
    end

    File.open("pageinfo.csv", "w") { |file| file.write content }
  end

  private
    def self.new_line
      "\n"
    end

    def self.get_host(uri)
      (uri.port.eql?(443) ? "https://" : "http://") +
      uri.host +
      (uri.port.eql?(80) ? "" : ":#{uri.port}")
    end

    def self.get_info(conn, page)
      @@no = @@no.next
      puts "#{@@no}. #{conn.effective_url}"
      [
        "\"#{conn.effective_url}\"",
        "\"#{conn.response_code}\"",
        "\"#{conn.total_time}\"",
        "\"#{get_head(page, "title")}\"",
        "\"#{get_head(page, "description")}\"",
        "\"#{get_head(page, "keywords")}\"",
      ].join(",")
    end

    def self.get_head(page, type)
      case type
      when "title"
        page.at("title").text.strip rescue ""
      when "description"
        page.at("meta[name=description]").attribute("content").value.strip rescue ""
      when "keywords"
        page.at("meta[name=keywords]").attribute("content").value.strip rescue ""
      end
    end

    def self.get_full_url(link)
      if bad_link?(link)
        nil
      elsif link.match(/^\//)
        "#{@@main_host}#{valid_link(link)}"
      elsif link.match(@@main_host)
        valid_link(link)
      else
        "#{@@main_host}/#{link}"
      end
    end

    def self.bad_link?(link)
      [nil, "#"].include?(link) ||
      link.match(/^javascript/) ||
      (link.match(/^http/) && external_link?(link))
    end

    def self.external_link?(link)
      uri = URI.parse(link) rescue nil
      uri.nil? ? true : !@@main_host.eql?(get_host(uri))
    end

    def self.valid_link(link)
      if link.match(/\/$/)
        link[0..-2]
      elsif link.match(/\/\#$/)
        link[0..-3]
      else
        link
      end
    end

    def self.get_page_links(page)
      links = page.css("a:not([rel]),a[rel!=nofollow]").map do |link|
        link.attribute("href").value rescue nil
      end
      links.uniq.compact
    end
end
