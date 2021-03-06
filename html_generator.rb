require_relative "html_strings.rb"
require_relative "stats.rb"
require_relative "html_writer.rb"

class HtmlGenerator

  include HtmlWriter
  def gen_index(rounds)
    File.open("HTML/ZJUerXTCer.html", "w") do |f|
      wrap_html_body(f) do
        write_header(f, "ZJUerXTopCoder", ["index.css"])
        f.write("<h1 align=\"center\">ZJUer X TopCoder</h1>\n")
        f.write("<div class=\"divAllRank\">\n")

        # SRMs
        f.write("<div class=\"divSRM\">\n")
        f.write("<h2>Single Round Match</h2>\n")
        f.write("<table border=\"0\" cellspacing=\"0\" cellpadding=\"0\"><tbody>\n")
        f.write("<tr class=\"titleLine\"><td><span>Event</span></td><td><span>Date</span></td></tr>\n")
        srms = rounds.select {|round| round.type == :srm}
        srms.reverse_each do |round|
          f.write("#{round.table_string}\n") if round.has_records?
        end
        f.write("</tbody></table></div>\n")

        # Tours
        f.write("<div class=\"divTour\">\n")
        f.write("<h2>Tournament</h2>\n")
        f.write("<table border=\"0\" cellspacing=\"0\" cellpadding=\"0\"><tbody>\n")
	f.write("<tr class=\"titleLine\"><td><span>Event</span></td><td><span>Date</span></td></tr>\n")
        tours = rounds.select {|round| round.type == :tour}
        tours.reverse_each do |round|
          f.write("#{round.table_string}\n") if round.has_records?
        end
        f.write("</tbody></table></div>\n")

        # Stats & Others
        f.write(INDEX_SIDE_BAR)
      end
    end
  end

  def gen_round(round)
    File.open("HTML/round/#{round.id}.html", "w") do |f|
      wrap_html_body(f) do
        write_header(f, round.name, ["../round.css"])
        f.write("<h1><a href=\"http://www.topcoder.com/stat?c=round_stats&rd=#{round.id}\" class=\"eventText\">#{round.name}</a></h1>\n")

        round.write_records_html(f)
        # Back link
        f.write(back_link_html(1))
      end
    end
  end

  def gen_coder(coder, coders)
    File.open("HTML/coder/#{coder.id}.html", "w") do |f|
      wrap_html_body(f) do
        write_header(f, coder.name, ["../coder.css"])
        f.write("<h1><a href=\"http://www.topcoder.com/tc?module=MemberProfile&cr=#{coder.id}\" class=\"ratingText#{Util.rating_color(coder.rating)}\">#{coder.name}</a></h1>\n")
        f.write("<div class=\"statDualDiv\">\n")
        f.write(coder.stat_table_html)
        coder.write_con_table_html(f, coders)
        f.write("</div>\n")
        coder.write_history_table_html(f)
        f.write(back_link_html(1))
      end
    end
  end

  def gen_all(rounds, coders)
    gen_index(rounds)

    rounds.each {|round| gen_round(round) if round.has_records?}
    coders.each_value {|coder| gen_coder(coder, coders) if coder.has_records?}

    stats = Stats.new
    stats.gen_all(rounds, coders)
  end

end
